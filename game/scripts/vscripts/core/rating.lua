-- Deterministic rating policy, independent of game engine.
local Rating = {}
function Rating.apply(winner_rating, loser_rating)
  assert(type(winner_rating) == "number" and winner_rating >= 0)
  assert(type(loser_rating) == "number" and loser_rating >= 0)
  return winner_rating + 25, math.max(0, loser_rating - 25)
end
return Rating
