-- Pure Lua rules engine; no Dota runtime dependencies.
local Match = {}
Match.__index = Match

function Match.new()
  return setmetatable({status = "active", winner = nil, reason = nil, disconnected = {}, disconnected_at = {}, finished_at = nil, overtime = false}, Match)
end

function Match:finish(team, reason, now)
  if self.status ~= "active" then return false end
  if team ~= 2 and team ~= 3 then return false end
  self.status, self.winner, self.reason, self.finished_at = "finished", team, reason, now
  return true
end

function Match:death(victim_team, now)
  if victim_team ~= 2 and victim_team ~= 3 then return false end
  return self:finish(victim_team == 2 and 3 or 2, "first_kill", now)
end

function Match:tower_destroyed(tower_team, is_mid_t1, is_denied, now)
  if not is_mid_t1 or is_denied then return false end
  if tower_team ~= 2 and tower_team ~= 3 then return false end
  return self:finish(tower_team == 2 and 3 or 2, "mid_t1", now)
end

function Match:timeout(radiant_networth, dire_networth, now, game_seconds)
  if self.status ~= "active" then return false end
  if type(game_seconds) ~= "number" or game_seconds < 600 then return false end
  if not self.overtime then
    if radiant_networth > dire_networth then return self:finish(2, "networth", now) end
    if dire_networth > radiant_networth then return self:finish(3, "networth", now) end
    self.overtime = true
  end
  if game_seconds < 900 then return false end
  if radiant_networth > dire_networth then return self:finish(2, "overtime_networth", now) end
  if dire_networth > radiant_networth then return self:finish(3, "overtime_networth", now) end
  self.status, self.winner, self.reason, self.finished_at = "draw", nil, "overtime_draw", now
  return true
end

function Match:disconnect(team, now)
  if self.status ~= "active" or (team ~= 2 and team ~= 3) then return false end
  if not self.disconnected[team] then self.disconnected_at[team] = now end
  self.disconnected[team] = true
  if self.disconnected[2] and self.disconnected[3] then
    self.status, self.reason = "cancelled", "both_disconnected"
  end
  return true
end

function Match:reconnect(team)
  if self.status ~= "active" then return false end
  self.disconnected[team] = nil
  self.disconnected_at[team] = nil
  return true
end

function Match:check_disconnect_timeout(now, grace_seconds)
  if self.status ~= "active" then return false end
  if type(now) ~= "number" or type(grace_seconds) ~= "number" then return false end
  if self.disconnected[2] and self.disconnected[3] then
    self.status, self.reason = "cancelled", "both_disconnected"
    return true
  end
  for _, team in ipairs({2, 3}) do
    local since = self.disconnected_at[team]
    if self.disconnected[team] and type(since) == "number" and now - since >= grace_seconds then
      return self:finish(team == 2 and 3 or 2, "disconnect_forfeit", now)
    end
  end
  return false
end

function Match:rating_delta(radiant_rating, dire_rating)
  if self.status ~= "finished" then return 0, 0 end
  if self.winner == 2 then return 25, -math.min(25, dire_rating) end
  return -math.min(25, radiant_rating), 25
end

return Match
