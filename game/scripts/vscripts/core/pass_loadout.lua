-- Pure Lua cosmetic loadout. Ownership must come from an authoritative inventory.
local Rewards = require("core.pass_rewards")
local Loadout = {}
local by_id = {}
for _, item in ipairs(Rewards.CATALOG) do by_id[item.id] = item end
local function owns(owned, id)
  return type(owned) == "table" and owned[id] == true
end
function Loadout.equip(current, owned, kind, reward_id)
  assert(type(current) == "table" and type(kind) == "string", "invalid loadout")
  local next_loadout = {}
  for k,v in pairs(current) do next_loadout[k] = v end
  if reward_id == nil then
    next_loadout[kind] = nil
    return next_loadout, true
  end
  local item = by_id[reward_id]
  if not item or item.kind ~= kind or not owns(owned, reward_id) then
    return next_loadout, false
  end
  next_loadout[kind] = reward_id
  return next_loadout, true
end
function Loadout.sanitize(current, owned)
  local clean = {}
  if type(current) ~= "table" then return clean end
  for kind,id in pairs(current) do
    local item = by_id[id]
    if item and item.kind == kind and owns(owned,id) then clean[kind] = id end
  end
  return clean
end
return Loadout
