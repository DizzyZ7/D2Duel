-- Match telemetry extension. Run after 001_ranked_foundation.sql.
BEGIN;
ALTER TABLE d2duel.matches ADD COLUMN IF NOT EXISTS valve_match_id TEXT;
ALTER TABLE d2duel.matches ADD COLUMN IF NOT EXISTS game_duration_seconds INTEGER CHECK (game_duration_seconds >= 0);
ALTER TABLE d2duel.matches ADD COLUMN IF NOT EXISTS result_source TEXT;
CREATE UNIQUE INDEX IF NOT EXISTS uq_d2duel_valve_match_id
 ON d2duel.matches(valve_match_id) WHERE valve_match_id IS NOT NULL;
ALTER TABLE d2duel.match_players ADD COLUMN IF NOT EXISTS kills INTEGER CHECK (kills >= 0);
ALTER TABLE d2duel.match_players ADD COLUMN IF NOT EXISTS deaths INTEGER CHECK (deaths >= 0);
ALTER TABLE d2duel.match_players ADD COLUMN IF NOT EXISTS assists INTEGER CHECK (assists >= 0);
ALTER TABLE d2duel.match_players ADD COLUMN IF NOT EXISTS last_hits INTEGER CHECK (last_hits >= 0);
ALTER TABLE d2duel.match_players ADD COLUMN IF NOT EXISTS denies INTEGER CHECK (denies >= 0);
ALTER TABLE d2duel.match_players ADD COLUMN IF NOT EXISTS hero_damage BIGINT CHECK (hero_damage >= 0);
ALTER TABLE d2duel.match_players ADD COLUMN IF NOT EXISTS tower_damage BIGINT CHECK (tower_damage >= 0);
CREATE INDEX IF NOT EXISTS idx_match_players_history
 ON d2duel.match_players(steam_id, match_id);
COMMIT;
