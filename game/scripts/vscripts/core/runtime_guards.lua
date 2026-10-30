-- Pure Lua guardrails for addon-local experimental functionality.
local Guards = {}
function Guards.is_duel_team(team)
  return team == 2 or team == 3
end
function Guards.is_valid_duel_player(id, team)
  return type(id) == "number" and id >= 0 and id == math.floor(id)
    and Guards.is_duel_team(team)
end
function Guards.should_replace_hero(id, team, unit_name, selected, assigned)
  if not Guards.is_valid_duel_player(id, team) then return false end
  if type(assigned) ~= "table" or assigned[id] then return false end
  if type(selected) ~= "string" or selected == "" then return false end
  if type(unit_name) ~= "string" then return false end
  return unit_name ~= selected
end
function Guards.is_competitor_hero(id, team, assigned, is_real_hero, is_illusion)
  return Guards.is_valid_duel_player(id, team)
    and type(assigned) == "table" and assigned[id] == true
    and is_real_hero == true and is_illusion ~= true
end
-- Count only assigned participants; reject incomplete/ambiguous rosters.
function Guards.duel_networth(players, assigned, radiant, dire)
  if type(players) ~= "table" or type(assigned) ~= "table" then return nil end
  local totals, counts = {[radiant]=0,[dire]=0}, {[radiant]=0,[dire]=0}
  for _, player in ipairs(players) do
    if Guards.is_competitor_hero(player.id, player.team, assigned, true, false) then
      local nw = player.networth
      if type(nw) ~= "number" or nw < 0 or nw ~= nw or nw == math.huge then return nil end
      totals[player.team] = totals[player.team] + nw
      counts[player.team] = counts[player.team] + 1
    end
  end
  if counts[radiant] ~= 1 or counts[dire] ~= 1 then return nil end
  return totals[radiant], totals[dire]
end
return Guards
