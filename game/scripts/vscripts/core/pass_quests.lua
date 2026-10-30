-- Deterministic cosmetic-pass quests; server must authenticate matches.
local Q = {}
Q.DEFINITIONS = {
  play_one = {target=1, xp=40, event="completed_match"},
  play_three = {target=3, xp=80, event="completed_match"},
  win_one = {target=1, xp=60, event="ranked_win"},
}
local function valid_count(n)
  return type(n) == "number" and n >= 0 and n == math.floor(n)
    and n ~= math.huge
end
function Q.progress(definition_id, current, event)
  local def = Q.DEFINITIONS[definition_id]
  assert(def and valid_count(current), "invalid quest progress")
  local next_count = math.min(def.target, current + (event == def.event and 1 or 0))
  local completed_now = current < def.target and next_count == def.target
  return next_count, completed_now and def.xp or 0
end
return Q
