# Duel Pass quests — prototype

Quests are cosmetic progression only, not gameplay bonuses.

| Quest | Target | XP |
|---|---:|---:|
| Play one verified completed match | 1 | 40 |
| Play three verified completed matches | 3 | 80 |
| Win one verified ranked match | 1 | 60 |

These are proposed daily quest values, not active rewards. Each quest must be scoped by season, UTC day, player and quest ID. Claim XP at most once per completed quest. The same verified match may advance multiple distinct quests but may never advance a quest twice.

**Critical security boundary:** `pass_quests.lua` is deterministic progress math, NOT an authoritative match validator, grant ledger or payment service. Never accept client-provided `completed_match` or `ranked_win` events. Backend must deduplicate match IDs, reject cancelled/drawn matches for wins, enforce 300 XP/day cap across quests and match grants, and persist progress atomically with XP grants.

No pass XP or premium entitlement is enabled in the Dota runtime yet.
