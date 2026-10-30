-- Pure policy for the pre-match connection window; not yet engine-wired.
local Ready = {}
Ready.__index = Ready
function Ready.new(started_at, window)
  assert(type(started_at) == "number" and started_at == started_at)
  assert(type(window) == "number" and window > 0)
  return setmetatable({started_at=started_at, window=window, ready={[2]=false,[3]=false}, status="waiting"}, Ready)
end
function Ready:mark(team, connected)
  if self.status ~= "waiting" or (team ~= 2 and team ~= 3) then return false end
  self.ready[team] = connected == true
  if self.ready[2] and self.ready[3] then self.status = "ready" end
  return true
end
function Ready:poll(now)
  if self.status ~= "waiting" then return self.status end
  if type(now) ~= "number" or now ~= now then return self.status end
  if now - self.started_at >= self.window then self.status = "cancelled" end
  return self.status
end
return Ready
