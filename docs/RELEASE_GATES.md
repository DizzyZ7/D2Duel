# D2Duel release gates

## CI (automated)
- Lua 5.1 syntax validation for every Lua source and spec.
- Run every `tests/*_spec.lua` test.
- CI does **not** execute the Dota 2 engine or validate game APIs.

## Local Workshop Tools (manual)
- Create/compile an actual Hammer mid-only map with valid spawns, towers, Ancients, lane creep paths.
- Confirm `addon_init.lua` and `addon_game_mode.lua` load without errors.
- Confirm random hero selection for two players, with no hero-selection deadlock.
- Confirm one kill, enemy mid T1, and net-worth at 10:00 each finalize exactly once.
- Confirm a 10:00 net-worth tie continues to overtime.
- Verify disconnect handling while paused with a **pause-safe real-time clock**.
- Verify dual-disconnect cancellation closes session without rating changes.
- Verify ordinary game-end presentation and losing Ancient destruction.
- Verify Turbo economy, neutral/rune restrictions, and ward protection.
- Verify authoritative persistence of MMR, signed results, and idempotency.

No claim of playable Workshop release until all manual checks pass.
