# Disconnect protocol v1

The pure state machine is implemented in `core/match_state.lua` and exercised by `tests/disconnect_spec.lua`.

## Required production integration
- On an authoritative player disconnect, call `match:disconnect(team, wall_clock_seconds)`.
- Pause the active game while one participant is absent.
- Poll `match:check_disconnect_timeout(wall_clock_seconds, 120)` from a callback **confirmed to execute while paused**.
- On reconnect call `match:reconnect(team)`; unpause only when both players are connected.
- If the second player disconnects before any winner is finalized, mark match cancelled; do not send rating updates.
- If timeout finalizes a winner, persist an idempotent signed result and end the game once.
- Validate event names, PlayerID field, pause behavior and available wall clock in Workshop Tools.

## Known blocker
`addon_game_mode.lua` still does not wire the grace clock into the engine. Its current `SetThink` callback may stop while the game is paused. Connecting the grace logic without a pause-safe wall-clock callback could create a match that never finishes. Do not claim disconnect-forfeit works in Dota until tested with two clients.

## Matchmaking integrity
Lobby slots must be limited to 2. A cancelled game is not a loss for either player. Player-hosted or client-submitted outcomes must never be trusted for public MMR.
