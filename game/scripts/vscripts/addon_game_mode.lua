-- D2Duel engine integration (experimental; requires Dota 2 Workshop Tools testing).
if D2Duel == nil then D2Duel = class({}) end
local Match = require("core.match_state")
local Config = require("core.match_config")
local HeroAssignment = require("core.hero_assignment")
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
  self.hero_rolls = HeroAssignment.roll({RADIANT, DIRE}, RandomInt)
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
  if id == nil or id < 0 or self.hero_assigned[id] then return end
  local selected = self.hero_rolls[team]
  if not selected then return end
  self.hero_assigned[id] = true -- set before replacement to avoid spawn recursion
  if unit:GetUnitName() ~= selected then
    local gold = PlayerResource:GetGold(id)
    local xp = unit:GetCurrentXP()
    PlayerResource:ReplaceHeroWith(id, selected, gold, xp)
  end
  print("[D2Duel] Assigned player " .. tostring(id) .. " hero " .. selected)
end

function D2Duel:OnEntityKilled(event)
  if self.match.status ~= "active" then return end
  local victim = EntIndexToHScript(event.entindex_killed or -1)
  if not victim or victim:IsNull() then return end
  local team = victim:GetTeamNumber()
  if victim:IsRealHero() and not victim:IsIllusion() then
    if self.match:death(team, GameRules:GetGameTime()) then self:Finish() end
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
    if self.match.status == "cancelled" then
      GameRules:SetGamePaused(false)
      -- Cancellation is deliberately not represented as a ranked win.
      print("[D2Duel] Cancelled: both players disconnected; no rating change")
    else
      GameRules:SetGamePaused(true)
    end
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
  -- NOTE: Think callbacks may not run during a pause. This is not a pause-safe timeout.
  if self.match:check_disconnect_timeout(Time(), Config.reconnect_grace_seconds) then
    if self.match.status == "finished" then self:Finish() end
    return 1
  end
  if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then return 1 end
  if GameRules:GetDOTATime(false, false) >= Config.match_limit_seconds then
    local networth = {[RADIANT] = 0, [DIRE] = 0}
    for id = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
      if PlayerResource:IsValidPlayerID(id) then
        local team = PlayerResource:GetTeam(id)
        if networth[team] ~= nil then networth[team] = networth[team] + PlayerResource:GetNetWorth(id) end
      end
    end
    if self.match:timeout(networth[RADIANT], networth[DIRE], GameRules:GetGameTime(), GameRules:GetDOTATime(false, false)) then
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
