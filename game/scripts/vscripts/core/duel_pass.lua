-- Pure Lua Duel Pass progression policy. Never affects competitive match rules.
local Pass = {}
Pass.MAX_LEVEL = 50
Pass.XP_PER_LEVEL = 100
Pass.MAX_XP = Pass.MAX_LEVEL * Pass.XP_PER_LEVEL
Pass.DAILY_XP_CAP = 300

local function valid_integer(n)
  return type(n) == "number" and n == n and n ~= math.huge
    and n ~= -math.huge and n >= 0 and n == math.floor(n)
end

function Pass.level(total_xp)
  assert(valid_integer(total_xp), "invalid pass XP")
  return math.min(Pass.MAX_LEVEL, math.floor(total_xp / Pass.XP_PER_LEVEL))
end

function Pass.grant(total_xp, earned_today, requested_xp)
  assert(valid_integer(total_xp) and valid_integer(earned_today)
    and valid_integer(requested_xp), "invalid XP grant")
  local room = math.max(0, Pass.DAILY_XP_CAP - earned_today)
  local award = math.min(requested_xp, room, math.max(0, Pass.MAX_XP - total_xp))
  return total_xp + award, earned_today + award, award
end

function Pass.reward_available(level, premium_owned, reward_level, premium_reward)
  if not valid_integer(level) or not valid_integer(reward_level)
    or reward_level < 1 or reward_level > Pass.MAX_LEVEL then return false end
  return level >= reward_level and (not premium_reward or premium_owned == true)
end

return Pass
