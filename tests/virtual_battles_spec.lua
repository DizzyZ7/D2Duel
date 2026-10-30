package.path = "game/scripts/vscripts/?.lua;game/scripts/vscripts/?/init.lua;" .. package.path
local Match = require("core.match_state")
local Result = require("core.match_result")
local counts = {kill=0,tower=0,networth=0,draw=0,solo_timeout=0,shared_outage=0,reconnected=0,abandon=0,late_dual=0,already_final=0}
for i=1,100 do
  local m = Match.new()
  local kind = (i-1)%10
  local name
  if kind==0 then
    assert(m:death(3,20)); assert(m.winner==2); name="kill"
  elseif kind==1 then
    assert(m:tower_destroyed(2,true,false,30)); assert(m.winner==3); name="tower"
  elseif kind==2 then
    assert(m:timeout(300,200,600,600)); assert(m.winner==2); name="networth"
  elseif kind==3 then
    assert(not m:timeout(100,100,600,600))
    assert(m:timeout(100,100,900,900)); assert(m.status=="draw"); name="draw"
  elseif kind==4 then
    assert(m:disconnect(2,10))
    assert(not m:check_disconnect_timeout(69,60))
    assert(m:check_disconnect_timeout(70,60)); assert(m.winner==3); name="solo_timeout"
  elseif kind==5 then
    assert(m:disconnect(2,10)); assert(m:disconnect(3,11))
    assert(not m:check_disconnect_timeout(70,60))
    assert(m:check_disconnect_timeout(71,60)); assert(m.status=="cancelled"); name="shared_outage"
  elseif kind==6 then
    assert(m:disconnect(2,10)); assert(m:reconnect(2))
    assert(not m:check_disconnect_timeout(100,60))
    assert(m:death(3,101)); assert(m.winner==2); name="reconnected"
  elseif kind==7 then
    assert(m:abandon(2,5)); assert(m.winner==3); name="abandon"
  elseif kind==8 then
    assert(m:disconnect(2,10)); assert(m:disconnect(3,20))
    assert(m:check_disconnect_timeout(70,60)); assert(m.winner==3); name="late_dual"
  else
    assert(m:death(3,4)); assert(not m:abandon(2,5))
    assert(not m:disconnect(2,6)); assert(m.winner==2); name="already_final"
  end
  local result = Result.snapshot(m,"simulation-"..i)
  assert(result.status==m.status and result.winner==m.winner)
  local a,b=m:rating_delta(100,100)
  if m.status=="draw" or m.status=="cancelled" then
    assert(a==0 and b==0)
  else
    assert((a==25 and b==-25) or (a==-25 and b==25))
  end
  counts[name]=counts[name]+1
end
for name,count in pairs(counts) do assert(count==10,name.." "..count) end
print("virtual_battles_spec: OK (100 deterministic sessions; 10 scenarios x 10)")
