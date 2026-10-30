# Duel Pass — design and security contract (proposal)

## Goals
Seasonal cosmetics and identity for ranked 1v1. **No pay-to-win.** The pass never changes damage, abilities, vision, gold, XP, matchmaking, match time, hero rolls or MMR.

## Season 1: Eclipse
- 50 levels; 100 pass XP per level (initial balancing targets, subject to playtesting).
- Free and premium tracks; free players keep earned rewards when premium is purchased later.
- Cosmetics: player emblem, loading-screen frame, profile banner, seasonal title, spawn aura, restrained victory effect, optional kill announcement skin, Ancient defeat visual.
- Every gameplay-relevant particle must be visibility-safe, rate-limited and user-toggleable; never hide heroes, wards, spells or tower projectiles.
- Premium ownership and claimed items must be verified server-side; no client-provided entitlement.
- Cosmetics must be custom/original or properly licensed; do not reuse Valve hero or item artwork without permission.

## Progression and anti-abuse
- XP only from authenticated completed eligible matches; never grant XP for cancelled matches or unverifiable client claims.
- Match reward policy and daily quests require backend verification, anti-farming, duplicate match ID protection and abuse controls.
- Pure Lua module `core/duel_pass.lua` only provides deterministic XP math and reward eligibility. It is **not** a secure backend, purchase integration or inventory.
- Current draft cap: 300 pass XP per UTC day, 5000 XP total; backend owns UTC reset and grant ledger.
- A season has immutable ID, start/end timestamps, and versioned rewards. No automatic loss of already claimed permanent cosmetics at season end.

## Planned cosmetics
1. Levels 1–10: free emblem, premium profile frame and spawn accent.
2. Levels 11–20: free title, premium loading card and subtle teleport flourish.
3. Levels 21–30: free banner, premium victory signature.
4. Levels 31–40: free seasonal badge, premium kill-announcement style.
5. Levels 41–50: free commemorative emblem, premium Eclipse champion aura and Ancient finish effect.

## Backend contract (not implemented)
- `season_id`, `steam_id`, `premium_entitlement`, `xp_total`, `daily_xp`, `daily_utc_date`.
- Idempotent `xp_grants` keyed by `(season_id, steam_id, match_id, grant_type)`.
- Claimed rewards keyed by `(season_id, steam_id, reward_id)`.
- Premium purchase verification via platform-approved payment integration; do not trust browser or Panorama flags.
- Keep pass progression separate from ranked rating transactions.

## Release gate
Pass cosmetics and XP are disabled until two-client Workshop tests and an authoritative persistence backend exist. Never ship an in-memory-only paid entitlement.
