# Two-client acceptance checklist

The addon Lua entrypoint now hooks `npc_spawned` and assigns a pre-rolled hero per team through `PlayerResource:ReplaceHeroWith`. This is an **experimental integration** and is not verified in Dota 2.

## Must validate before declaring playable

1. Both players occupy exactly one Radiant/Dire slot. No third player can enter the lobby.
2. With zero hero selection time, each player must actually receive a real hero spawn. If no hero spawns, the current `npc_spawned` hook will never fire; replace with an explicit hero-selection mechanism.
3. Check `RandomInt`, `ReplaceHeroWith`, `GetGold`, `GetCurrentXP` on the installed Dota build. Verify that replacement does not recurse or reset the assigned hero.
4. Verify the first hero death (not illusions, clones, neutrals) ends the game exactly once.
5. Validate mid T1 entity names and ensure denies cannot trigger victory.
6. Confirm the game ends in the normal Dota post-game UI, and add an actual losing-Ancient destruction visual.
7. Check that `SetGamePaused(true)` works on a custom game server. Confirm whether `SetThink` executes while paused. **Do not rely on the current disconnect timeout until that is established.**
8. Both disconnect before the outcome: cancelled with no rating. Cancellation still needs a verified way to close the match.
9. Add a Hammer map and compile it, then test both clients. No map files are included yet.
10. Public MMR must remain disabled until authenticated, idempotent server results exist.

## Development gates

- Unit-level Lua rules: source written, tests not executed in this environment.
- Dota engine integration: source written, untested.
- Map: not created.
- Ranked backend: not created.
- Workshop publication: not performed.
