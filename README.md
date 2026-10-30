# D2Duel — Ranked Mid 1v1

Dota 2 Arcade custom game (work in progress). **Not yet playable or published.**

## Locked rules
- Two players maximum, one Radiant and one Dire; single Ranked queue.
- Independent random heroes, mid-only, Turbo-style economy.
- No neutral creeps or runes; wards cannot be destroyed.
- First enemy hero death OR first enemy mid T1 destruction wins immediately.
- At 10:00 in-game time, higher net worth wins. Equal net worth requires overtime.
- Winner +25 MMR; loser -25 MMR, minimum rating 0.
- After a result, destroy losing Ancient visually and end via standard Dota game winner flow.
- One disconnect pauses; both disconnect before a result cancels without rating changes.
- Reconnect grace target: 120 real-time seconds (engine behavior to validate).

## Status
This repository begins with a pure Lua match-state module and standalone tests. Engine integration, map, hero selection, Turbo configuration, UI, reliable result authentication and publishing remain TODO.

## Test
Install Lua 5.1+ and run: `lua tests/match_state_spec.lua`.

## Security
Do not award public MMR based on untrusted player-hosted results. Ranked persistence is gated on verified authoritative match results.
