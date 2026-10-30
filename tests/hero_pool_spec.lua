package.path = "game/scripts/vscripts/?.lua;game/scripts/vscripts/?/init.lua;" .. package.path
local pool = require("core.hero_pool")
local heroes = pool.list()
assert(#heroes >= 2)
local seen = {}
for _, hero in ipairs(heroes) do
  assert(type(hero) == "string" and hero:match("^npc_dota_hero_"))
  assert(not seen[hero], "duplicate hero")
  seen[hero] = true
end
assert(pool.choose(function(a,b) return a end) == heroes[1])
assert(pool.choose(function(a,b) return b end) == heroes[#heroes])
print("hero_pool_spec: OK")
