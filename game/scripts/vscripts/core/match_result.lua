-- Pure, immutable snapshot for an already-finalized match.
-- No network calls, no rating persistence and no client authority.
local Result = {}
function Result.snapshot(match, match_id)
  assert(type(match_id) == "string" and #match_id > 0, "match_id required")
  assert(match.status == "finished" or match.status == "cancelled" or match.status == "draw", "match not final")
  if match.status == "finished" then
    assert(match.winner == 2 or match.winner == 3, "invalid winner")
  end
  return {
    match_id = match_id,
    status = match.status,
    winner = match.winner,
    reason = match.reason,
    finished_at = match.finished_at,
    ranked_eligible = false, -- until authenticated server results exist
  }
end
return Result
