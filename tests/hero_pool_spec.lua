package.path = "game/scripts/vscripts/?.lua;game/scripts/vscripts/?/init.lua;" .. package.path
local pool = require("core.hero_pool")
local heroes = pool.from_kv({DOTAHeroes={
 npc_dota_hero_base={}, npc_dota_hero_axe={Enabled="1"},
 npc_dota_hero_lina={}, npc_dota_hero_test_disabled={Enabled="0"},
 npc_dota_hero_new_release={CMEnabled="0"}
}})
assert(#heroes == 3)
assert(heroes[1] == "npc_dota_hero_axe")
assert(heroes[3] == "npc_dota_hero_new_release")
assert(pool.choose(function(a,b) return a end,heroes) == heroes[1])
assert(pool.choose(function(a,b) return b end,heroes) == heroes[#heroes])
assert(not pcall(pool.from_kv, {}))
print("hero_pool_spec: OK")
