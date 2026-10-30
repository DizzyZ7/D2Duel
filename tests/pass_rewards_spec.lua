package.path = "game/scripts/vscripts/?.lua;game/scripts/vscripts/?/init.lua;" .. package.path
local R = require("core.pass_rewards")
assert(R.validate())
local function has(items, name)
  for _, item in ipairs(items) do if item==name then return true end end
  return false
end
local free = R.available(50, false)
assert(has(free,"eclipse_emblem"))
assert(has(free,"eclipse_commemorative"))
assert(not has(free,"eclipse_champion"))
local paid = R.available(50, true)
assert(has(paid,"eclipse_champion"))
assert(has(paid,"eclipse_victory"))
assert(not has(R.available(24,true),"eclipse_victory"))
assert(#R.available(0,true)==0)
assert(not pcall(R.available,-1,true))
assert(not pcall(R.available,0/0,true))
print("pass_rewards_spec: OK")
