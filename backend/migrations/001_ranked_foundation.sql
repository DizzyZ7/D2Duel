-- D2Duel ranked storage v1. Run only after backup and review.
BEGIN;
CREATE SCHEMA IF NOT EXISTS d2duel;
CREATE TABLE IF NOT EXISTS d2duel.players (
 steam_id BIGINT PRIMARY KEY CHECK (steam_id > 0),
 created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS d2duel.seasons (
 id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 name TEXT NOT NULL UNIQUE,
 starts_at TIMESTAMPTZ NOT NULL,
 ends_at TIMESTAMPTZ,
 CHECK (ends_at IS NULL OR ends_at > starts_at)
);
CREATE TABLE IF NOT EXISTS d2duel.ratings (
 steam_id BIGINT NOT NULL REFERENCES d2duel.players(steam_id),
 season_id BIGINT NOT NULL REFERENCES d2duel.seasons(id),
 mmr INTEGER NOT NULL DEFAULT 0 CHECK (mmr >= 0),
 wins INTEGER NOT NULL DEFAULT 0 CHECK (wins >= 0),
 losses INTEGER NOT NULL DEFAULT 0 CHECK (losses >= 0),
 PRIMARY KEY (steam_id, season_id)
);
CREATE TABLE IF NOT EXISTS d2duel.matches (
 id UUID PRIMARY KEY,
 season_id BIGINT NOT NULL REFERENCES d2duel.seasons(id),
 status TEXT NOT NULL CHECK (status IN ('pending','completed','cancelled','draw')),
 winner_steam_id BIGINT REFERENCES d2duel.players(steam_id),
 reason TEXT,
 started_at TIMESTAMPTZ NOT NULL,
 finished_at TIMESTAMPTZ,
 CHECK ((status = 'completed' AND winner_steam_id IS NOT NULL AND finished_at IS NOT NULL)
    OR (status <> 'completed' AND winner_steam_id IS NULL)),
 CHECK (finished_at IS NULL OR finished_at >= started_at)
);
CREATE TABLE IF NOT EXISTS d2duel.match_players (
 match_id UUID NOT NULL REFERENCES d2duel.matches(id),
 steam_id BIGINT NOT NULL REFERENCES d2duel.players(steam_id),
 team SMALLINT NOT NULL CHECK (team IN (2,3)),
 hero_name TEXT,
 net_worth BIGINT CHECK (net_worth >= 0),
 PRIMARY KEY (match_id, steam_id),
 UNIQUE (match_id, team)
);
CREATE TABLE IF NOT EXISTS d2duel.rating_transactions (
 match_id UUID NOT NULL REFERENCES d2duel.matches(id),
 steam_id BIGINT NOT NULL REFERENCES d2duel.players(steam_id),
 season_id BIGINT NOT NULL,
 delta INTEGER NOT NULL CHECK (delta BETWEEN -25 AND 25),
 mmr_before INTEGER NOT NULL CHECK (mmr_before >= 0),
 mmr_after INTEGER NOT NULL CHECK (mmr_after >= 0),
 created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
 PRIMARY KEY (match_id, steam_id),
 FOREIGN KEY (steam_id, season_id) REFERENCES d2duel.ratings(steam_id, season_id),
 FOREIGN KEY (match_id, steam_id) REFERENCES d2duel.match_players(match_id, steam_id),
 CHECK (mmr_after = mmr_before + delta)
);
CREATE INDEX IF NOT EXISTS idx_matches_season_finished ON d2duel.matches(season_id, finished_at DESC);
CREATE INDEX IF NOT EXISTS idx_ratings_leaderboard ON d2duel.ratings(season_id, mmr DESC);
COMMIT;
