package.path = "game/scripts/vscripts/?.lua;game/scripts/vscripts/?/init.lua;" .. package.path
local Assignment = require("core.hero_assignment")
local Pool = require("core.hero_pool")
local rolls = {1, #Pool.list()}
local i = 0
local result = Assignment.roll({2,3}, function(low, high)
  i = i + 1
  assert(low == 1 and high == #Pool.list())
  return rolls[i]
end)
assert(result[2] == Pool.list()[1])
assert(result[3] == Pool.list()[#Pool.list()])
assert(i == 2)
local duplicate = Assignment.roll({2,3}, function() return 1 end)
assert(duplicate[2] == duplicate[3])
print("hero_assignment_spec: OK")
