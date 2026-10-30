-- D2Duel engine integration (experimental; requires Dota 2 Workshop Tools testing).
if D2Duel == nil then D2Duel = class({}) end
local Match = require("core.match_state")
local Config = require("core.match_config")
local HeroAssignment = require("core.hero_assignment")
local HeroPool = require("core.hero_pool")
local Guards = require("core.runtime_guards")
local RADIANT, DIRE = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS

function Precache(context) end
function Activate()
  GameRules.D2Duel = D2Duel()
  GameRules.D2Duel:InitGameMode()
end

function D2Duel:InitGameMode()
  self.match = Match.new()
  self.players = {}
  self.hero_assigned = {}
  -- Load the live installed roster; fail closed if engine KV cannot be read.
  local kv = LoadKeyValues("scripts/npc/npc_heroes.txt")
  assert(type(kv) == "table", "D2Duel requires installed hero KV")
  self.hero_roster = HeroPool.from_kv(kv)
  self.hero_rolls = HeroAssignment.roll({RADIANT, DIRE}, RandomInt, self.hero_roster)
  self.result_committed = false
  GameRules:SetCustomGameTeamMaxPlayers(RADIANT, Config.max_players_per_team)
  GameRules:SetCustomGameTeamMaxPlayers(DIRE, Config.max_players_per_team)
  GameRules:SetHeroSelectionTime(Config.hero_selection_seconds)
  GameRules:SetPreGameTime(Config.pregame_seconds)
  ListenToGameEvent("npc_spawned", Dynamic_Wrap(D2Duel, "OnNpcSpawned"), self)
  ListenToGameEvent("entity_killed", Dynamic_Wrap(D2Duel, "OnEntityKilled"), self)
  ListenToGameEvent("player_disconnect", Dynamic_Wrap(D2Duel, "OnPlayerDisconnect"), self)
  ListenToGameEvent("player_reconnected", Dynamic_Wrap(D2Duel, "OnPlayerReconnect"), self)
  GameRules:GetGameModeEntity():SetThink("OnThink", self, "D2DuelThink", 1)
end

-- Assign once per player, replacing the first spawned real hero.
-- Workshop validation required for ReplaceHeroWith and hero-selection timing.
function D2Duel:OnNpcSpawned(event)
  if not event.entindex then return end
  local unit = EntIndexToHScript(event.entindex)
  if not unit or unit:IsNull() or not unit:IsRealHero() or unit:IsIllusion() then return end
  local team = unit:GetTeamNumber()
  if team ~= RADIANT and team ~= DIRE then return end
  local id = unit:GetPlayerOwnerID()
  local selected = self.hero_rolls[team]
  if not Guards.is_valid_duel_player(id, team) or self.hero_assigned[id] or (self.hero_replacing and self.hero_replacing[id]) then return end
  if not selected then return end
  local replace = Guards.should_replace_hero(id, team, unit:GetUnitName(), selected, self.hero_assigned)
  if not replace then
    self.hero_assigned[id] = true
    print("[D2Duel] Assigned player " .. tostring(id) .. " hero " .. selected)
    return
  end
  -- Guard against recursive npc_spawned events while replacing.
  self.hero_replacing = self.hero_replacing or {}
  if self.hero_replacing[id] then return end
  self.hero_replacing[id] = true
  local gold = PlayerResource:GetGold(id)
  local xp = unit:GetCurrentXP()
  local ok, new_hero = pcall(function()
    return PlayerResource:ReplaceHeroWith(id, selected, gold, xp)
  end)
  self.hero_replacing[id] = nil
  if not ok or not new_hero or new_hero:IsNull()
    or new_hero:GetUnitName() ~= selected then
    print("[D2Duel] Hero replacement failed for player " .. tostring(id))
    return
  end
  self.hero_assigned[id] = true
  print("[D2Duel] Assigned player " .. tostring(id) .. " hero " .. selected)
end

function D2Duel:OnEntityKilled(event)
  if self.match.status ~= "active" then return end
  local victim = EntIndexToHScript(event.entindex_killed or -1)
  if not victim or victim:IsNull() then return end
  local team = victim:GetTeamNumber()
  if victim:IsRealHero() then
    local id = victim:GetPlayerOwnerID()
    if Guards.is_competitor_hero(id, team, self.hero_assigned, true, victim:IsIllusion()) then
      if self.match:death(team, GameRules:GetGameTime()) then self:Finish() end
    end
    return
  end
  if victim:IsTower() then
    local name = victim:GetUnitName() or ""
    local is_mid_t1 = name == "npc_dota_goodguys_tower1_mid" or name == "npc_dota_badguys_tower1_mid"
    if self.match:tower_destroyed(team, is_mid_t1, false, GameRules:GetGameTime()) then self:Finish() end
  end
end

function D2Duel:OnPlayerDisconnect(event)
  local id = event.PlayerID
  if id == nil or id < 0 then return end
  local team = PlayerResource:GetTeam(id)
  if team ~= RADIANT and team ~= DIRE then return end
  if self.match:disconnect(team, Time()) then
    GameRules:SetGamePaused(true)
  end
end

function D2Duel:OnPlayerReconnect(event)
  local id = event.PlayerID
  if id == nil or id < 0 then return end
  local team = PlayerResource:GetTeam(id)
  if self.match:reconnect(team) then
    if not self.match.disconnected[RADIANT] and not self.match.disconnected[DIRE] then
      GameRules:SetGamePaused(false)
    end
  end
end

function D2Duel:OnThink()
  if self.match.status ~= "active" then return 1 end
  -- WARNING: Think callbacks may not run while paused; timeout is NOT reliable yet.
  if self.match:check_disconnect_timeout(Time(), Config.reconnect_grace_seconds) then
    if self.match.status == "finished" then self:Finish() end
    return 1
  end
  if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then return 1 end
  if GameRules:GetDOTATime(false, false) >= Config.match_limit_seconds then
    local players = {}
    for id = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
      if PlayerResource:IsValidPlayerID(id) then
        players[#players + 1] = {id=id, team=PlayerResource:GetTeam(id), networth=PlayerResource:GetNetWorth(id)}
      end
    end
    local radiant_nw, dire_nw = Guards.duel_networth(players, self.hero_assigned, RADIANT, DIRE)
    if radiant_nw == nil then return 1 end
    if self.match:timeout(radiant_nw, dire_nw, GameRules:GetGameTime(), GameRules:GetDOTATime(false, false)) then
      if self.match.status == "finished" then self:Finish() end
      if self.match.status == "draw" then
        print("[D2Duel] Draw at 15:00; no MMR change. Engine draw shutdown pending.")
      end
    end
  end
  return 1
end

function D2Duel:Finish()
  if self.result_committed or self.match.status ~= "finished" then return end
  self.result_committed = true
  local loser = self.match.winner == RADIANT and DIRE or RADIANT
  -- Engine handles game-over and Ancient destruction presentation; verify in-client.
  print("[D2Duel] Winner " .. tostring(self.match.winner) .. ", loser " .. tostring(loser))
  GameRules:SetGameWinner(self.match.winner)
end
