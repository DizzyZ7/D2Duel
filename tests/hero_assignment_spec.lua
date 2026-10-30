package.path = "game/scripts/vscripts/?.lua;game/scripts/vscripts/?/init.lua;" .. package.path
local Assignment = require("core.hero_assignment")
local roster = {"npc_dota_hero_axe","npc_dota_hero_lina","npc_dota_hero_zuus"}
local i = 0
local result = Assignment.roll({2,3}, function(low,high)
 i = i + 1
 assert(low == 1 and high == #roster)
 return i
end, roster)
assert(result[2] == roster[1] and result[3] == roster[2] and i == 2)
local duplicate = Assignment.roll({2,3}, function() return 1 end, roster)
assert(duplicate[2] == duplicate[3])
print("hero_assignment_spec: OK")
