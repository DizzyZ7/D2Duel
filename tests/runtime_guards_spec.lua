package.path = "game/scripts/vscripts/?.lua;game/scripts/vscripts/?/init.lua;" .. package.path
local G = require("core.runtime_guards")
assert(G.is_valid_duel_player(0,2))
assert(G.is_valid_duel_player(1,3))
assert(not G.is_valid_duel_player(-1,2))
assert(not G.is_valid_duel_player(2,4))
assert(not G.is_valid_duel_player(1.5,2))
assert(G.should_replace_hero(0,2,"npc_dota_hero_axe","npc_dota_hero_lina",{}))
assert(not G.should_replace_hero(0,2,"npc_dota_hero_lina","npc_dota_hero_lina",{}))
assert(not G.should_replace_hero(0,2,"npc_dota_hero_axe","npc_dota_hero_lina",{[0]=true}))
assert(not G.should_replace_hero(0,4,"npc_dota_hero_axe","npc_dota_hero_lina",{}))
local assigned = {[0]=true,[1]=true}
assert(G.is_competitor_hero(0,2,assigned,true,false))
assert(G.is_competitor_hero(1,3,assigned,true,false))
assert(not G.is_competitor_hero(2,2,assigned,true,false))
assert(not G.is_competitor_hero(0,4,assigned,true,false))
assert(not G.is_competitor_hero(0,2,assigned,true,true))
assert(not G.is_competitor_hero(0,2,assigned,false,false))
assert(not G.is_competitor_hero(0,2,{},true,false))
local sample = {
 {id=0,team=2,networth=500},
 {id=1,team=3,networth=450},
 {id=2,team=2,networth=90000}
}
local a,b = G.duel_networth(sample,assigned,2,3)
assert(a == 500 and b == 450)
assert(G.duel_networth({sample[1]},assigned,2,3) == nil)
assert(G.duel_networth({sample[1],{id=1,team=3,networth=-1}},assigned,2,3) == nil)
assert(G.duel_networth({sample[1],sample[2],sample[2]},assigned,2,3) == nil)
print("runtime_guards_spec: OK")
