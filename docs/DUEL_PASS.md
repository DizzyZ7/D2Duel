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

## Premium pricing
- Target price: **USD 2.00** for an official Dota 2 Custom Game Pass, subject to Valve approval and pricing availability.\n- Valve documents Custom Game Pass entitlement as **30 days from purchase**, not a whole season; it does not auto-renew. Season cosmetics/progression must be designed independently of the 30-day paid entitlement.
- Premium unlocks cosmetic rewards for all already-earned levels, including retroactive eligibility after purchase.
- The free track remains available without payment.
- Currency conversion, local taxes, payment provider fees, platform rules and permitted payment rails must be validated before enabling checkout.
- The server must confirm the payment and bind entitlement to the correct Steam account and season. Client-side payment success is never sufficient.

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
- Premium entitlement verification must use Valve-approved Custom Game Pass ownership, if Valve approves D2Duel. Never trust browser or Panorama flags.
- Keep pass progression separate from ranked rating transactions.

## Release gate
Paid pass entitlement is disabled until Valve explicitly enables D2Duel Custom Game Pass, two-client Workshop tests pass and an authoritative persistence backend exists. Never ship an in-memory-only paid entitlement or third-party checkout.

## Official platform references\n- https://www.dota2.com/customgamepassfaq?l=english — curated eligibility, 30-day validity, no automatic renewal, free base game.\n- https://partner.steamgames.com/doc/features/microtransactions — Steam Wallet purchasing requirements.\n- Valve has previously enforced non-commercial Workshop terms against unauthorized third-party monetization; do not implement a payment bypass.\n