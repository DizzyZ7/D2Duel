-- Hero roster comes from the installed Dota 2 hero KV, not a fixed shortlist.
-- Inject the KV table to keep this module testable outside the engine.
local M = {}
function M.from_kv(kv)
  assert(type(kv) == "table", "hero KV table required")
  local source = kv.DOTAHeroes or kv
  local heroes = {}
  for name, data in pairs(source) do
    if type(name) == "string" and name:match("^npc_dota_hero_[%w_]+$")
      and name ~= "npc_dota_hero_base" and type(data) == "table"
      and tostring(data.Enabled or "1") ~= "0"
      and tostring(data.CMEnabled or "1") ~= "0" then
      heroes[#heroes + 1] = name
    end
  end
  table.sort(heroes)
  assert(#heroes > 0, "no enabled heroes in roster")
  return heroes
end
function M.choose(random_int, roster)
  assert(type(random_int) == "function" and type(roster) == "table" and #roster > 0)
  local index = random_int(1, #roster)
  assert(type(index) == "number" and index == math.floor(index) and index >= 1 and index <= #roster)
  return roster[index]
end
return M
