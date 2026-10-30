# Isolation and non-regression policy

D2Duel is a Dota 2 **custom game addon**. All changes must stay inside the addon repository and its own Workshop Tools installation.

## Hard rules
- Never overwrite or patch stock Dota 2 scripts, map files, items, heroes, or matchmaking configuration.
- Never modify another player's local files, client settings, or normal matchmaking.
- Keep experimental behavior behind explicit addon-local flags; no external MMR writes before trusted backend verification.
- Do not add global Lua monkey patches or hook standard Dota gameplay outside this custom match.
- Limit game actions to recognized Radiant/Dire participants in the D2Duel lobby.
- Require two-client Workshop Tools validation before describing the game as playable.
- Before publication: test fresh install, uninstall, map compilation, match exit, reconnect, and regular Dota launch.

## Limits
These rules and unit tests do not prove the addon cannot affect the engine. Only in-client integration testing can validate engine interactions. Avoid shipping untested engine calls as production-ready.
