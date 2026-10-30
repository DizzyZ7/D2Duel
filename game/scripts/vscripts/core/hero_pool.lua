-- Conservative hero pool for initial 1v1 testing; extend after balance checks.
local Pool = {
  "npc_dota_hero_axe",
  "npc_dota_hero_lina",
  "npc_dota_hero_lion",
  "npc_dota_hero_nevermore",
  "npc_dota_hero_queenofpain",
  "npc_dota_hero_sniper",
  "npc_dota_hero_viper",
  "npc_dota_hero_zuus",
}
local M = {}
function M.choose(random_int)
  local index = random_int(1, #Pool)
  assert(index >= 1 and index <= #Pool and index == math.floor(index))
  return Pool[index]
end
function M.list()
  local copy = {}
  for i, hero in ipairs(Pool) do copy[i] = hero end
  return copy
end
return M
