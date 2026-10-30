local Config = {
  max_players_per_team = 1,
  hero_selection_seconds = 0,
  pregame_seconds = 10,
  match_limit_seconds = 600,
  reconnect_grace_seconds = 120,
  win_rating = 25,
  lose_rating = 25,
  -- These multipliers are design targets, NOT yet wired into engine filters.
  gold_multiplier_target = 2,
  xp_multiplier_target = 2,
  disable_neutral_spawns = true,
  disable_runes = true,
  invulnerable_wards = true,
}
return Config
