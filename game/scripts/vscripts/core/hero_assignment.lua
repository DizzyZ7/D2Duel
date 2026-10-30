-- Deterministic assignment with injected RNG, independent of Dota engine.
-- The same hero can be rolled for both players: independent random selection.
local Pool = require("core.hero_pool")
local Assignment = {}
function Assignment.roll(teams, random_int)
  assert(type(teams) == "table" and type(random_int) == "function")
  local result = {}
  for _, team in ipairs(teams) do
    assert(result[team] == nil, "duplicate team")
    result[team] = Pool.choose(random_int)
  end
  return result
end
return Assignment
