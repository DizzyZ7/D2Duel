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
  if assigned[id] then return false end
  if type(selected) ~= "string" or selected == "" then return false end
  if type(unit_name) ~= "string" then return false end
  return unit_name ~= selected
end
return Guards
