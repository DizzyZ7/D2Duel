# Ranked result security gates

The in-memory `core/result_registry.lua` provides best-effort duplicate suppression inside **one running Lua process only**. It is not a ranking backend.

Do not award public MMR from client-provided results or a player-hosted addon. A real ranked backend needs:

1. Server-issued, unpredictable match IDs bound to two authenticated Steam identities.
2. A trusted authoritative match-result source; a bearer token in distributed client files is **not** sufficient.
3. Persistent storage with a unique constraint on match ID and a transaction updating both ratings once.
4. Validation of participant identities, final match state, outcome reason, and both disconnect policy.
5. Zero rating updates for `draw` or `cancelled`.
6. Replay/retry tests, concurrent duplicate submission tests, and audit logging.
7. Anti-abuse policy for rematches, alternate accounts, and suspicious result patterns.

Until these controls exist, `ranked_eligible` stays false.
