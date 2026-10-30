# D2Duel PostgreSQL foundation

Target: BotHost PostgreSQL, port 15811. Database credentials must NEVER be committed.

The migration `migrations/001_ranked_foundation.sql` creates only objects under schema `d2duel`. It does not delete or alter existing `public` tables.

## Deployment (manual, after backup)
1. Rotate the PostgreSQL password disclosed in chat and set `DATABASE_URL` in private hosting environment.
2. Back up the target database.
3. Review SQL and run it through a PostgreSQL client connected to the intended database.
4. Verify tables in `d2duel` and check grants. Prefer a dedicated restricted application role.
5. Do not award ranked MMR yet. Authentication of Dota server results, atomic settlement, retry queue and real engine integration remain unimplemented.

## Security
Player-hosted matches and client-originated claims are not authoritative. Do not expose PostgreSQL credentials to Panorama, client files, or distributed addon Lua. No direct database connection from game clients.

## Current scope
Schema only: players, seasons, ratings, matches, match participants, and idempotency-keyed rating ledger. No live database connection or data migration has been performed.
