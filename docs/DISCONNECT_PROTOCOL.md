# Disconnect protocol v2 (policy, not yet production-safe)

- One disconnect: pause, 60 real-time seconds to reconnect.
- A trusted, engine-confirmed abandon event can call `match:abandon(team, now)` to award immediate opponent victory. **No abandon event is wired yet.** Never infer abandon from ordinary disconnect.
- If both players disconnect within 5 seconds, treat it as a suspected shared outage: if both remain absent for 60 seconds after the later disconnect, cancel with no MMR. This is a heuristic, not proof of server failure. If one reconnects, the other can still forfeit at their own deadline. For gaps greater than 5 seconds, the first expired disconnect forfeits.\n- A server-confirmed outage should cancel the match regardless of the 5-second heuristic; authoritative outage detection is not wired yet.
- On reconnect, remove that team's disconnect timer. Resume only when both players are connected.
- No extra MMR penalty beyond the ordinary loss; results still require authenticated, idempotent persistence.
- **Critical blocker:** current Dota `SetThink` may stop during pause. A validated pause-safe real-time timer is required before treating timeout forfeits as working in-game.
- Do not wire premium pass progress to unverified disconnect results.
- Confirm event payloads, player identity, abandon signal, wall-clock behavior, reconnect and pause on two Dota clients.
