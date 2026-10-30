package.path = "game/scripts/vscripts/?.lua;game/scripts/vscripts/?/init.lua;" .. package.path
local Rating = require("core.rating")
assert(select(1, Rating.apply(0,0)) == 25)
assert(select(2, Rating.apply(0,0)) == 0)
assert(select(1, Rating.apply(100,200)) == 125)
assert(select(2, Rating.apply(100,200)) == 175)
print("rating_spec: OK")
