-- Cosmetic-only reward catalogue. No gameplay modifiers or purchase hooks.
local Rewards = {}
Rewards.CATALOG = {
  {id="eclipse_emblem", level=1, premium=false, kind="emblem"},
  {id="eclipse_frame", level=5, premium=true, kind="profile_frame"},
  {id="eclipse_title", level=10, premium=false, kind="title"},
  {id="eclipse_spawn", level=15, premium=true, kind="spawn_effect"},
  {id="eclipse_banner", level=20, premium=false, kind="profile_banner"},
  {id="eclipse_victory", level=25, premium=true, kind="victory_effect"},
  {id="eclipse_rank_badge", level=30, premium=false, kind="emblem"},
  {id="eclipse_announcement", level=35, premium=true, kind="kill_announcement"},
  {id="eclipse_commemorative", level=50, premium=false, kind="emblem"},
  {id="eclipse_champion", level=50, premium=true, kind="hero_aura"},
}
local allowed = {emblem=true, profile_frame=true, title=true, spawn_effect=true,
  profile_banner=true, victory_effect=true, kill_announcement=true, hero_aura=true}
function Rewards.validate()
  local seen = {}
  for _, item in ipairs(Rewards.CATALOG) do
    assert(type(item.id)=="string" and not seen[item.id], "duplicate reward")
    assert(type(item.level)=="number" and item.level>=1 and item.level<=50
      and item.level==math.floor(item.level), "invalid reward level")
    assert(type(item.premium)=="boolean" and allowed[item.kind], "invalid cosmetic")
    seen[item.id]=true
  end
  return true
end
function Rewards.available(level, premium)
  assert(type(level)=="number" and level>=0 and level==math.floor(level)
    and level~=math.huge, "invalid pass level")
  local items = {}
  for _, item in ipairs(Rewards.CATALOG) do
    if item.level<=level and (not item.premium or premium==true) then
      items[#items+1] = item.id
    end
  end
  return items
end
Rewards.validate()
return Rewards
