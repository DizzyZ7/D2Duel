-- In-memory idempotency for a single server process.
-- This is NOT durable persistence and does not authenticate match results.
local Registry = {}
Registry.__index = Registry

function Registry.new()
  return setmetatable({results = {}}, Registry)
end

function Registry:record(result)
  assert(type(result) == "table" and type(result.match_id) == "string" and #result.match_id > 0)
  assert(result.status == "finished" or result.status == "cancelled" or result.status == "draw")
  if self.results[result.match_id] then return false end
  self.results[result.match_id] = {
    match_id = result.match_id,
    status = result.status,
    winner = result.winner,
    reason = result.reason,
    ranked_eligible = false
  }
  return true
end

function Registry:get(match_id)
  return self.results[match_id]
end

return Registry
