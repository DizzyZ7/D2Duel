# Disconnect protocol v2 (policy, not yet production-safe)

- One disconnect: pause, 60 real-time seconds to reconnect.
- A trusted, engine-confirmed abandon event can call `match:abandon(team, now)` to award immediate opponent victory. **No abandon event is wired yet.** Never infer abandon from ordinary disconnect.
- If both players disconnect, do not cancel automatically: the first expired disconnect loses. Simultaneous timestamps resolve deterministically by team order; a future authoritative server-failure policy must supersede this if the server itself fails.
- On reconnect, remove that team's disconnect timer. Resume only when both players are connected.
- No extra MMR penalty beyond the ordinary loss; results still require authenticated, idempotent persistence.
- **Critical blocker:** current Dota `SetThink` may stop during pause. A validated pause-safe real-time timer is required before treating timeout forfeits as working in-game.
- Do not wire premium pass progress to unverified disconnect results.
- Confirm event payloads, player identity, abandon signal, wall-clock behavior, reconnect and pause on two Dota clients.
