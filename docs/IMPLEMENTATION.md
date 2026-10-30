# Implementation milestones

1. Build a minimal Workshop Tools addon and validate loading the Lua entrypoint.
2. Create/test a mid-only Hammer map and restrict each team to one player.
3. Integrate engine events with the pure match state module, including identifying *mid T1* and avoiding duplicate outcomes.
4. Random hero assignment with a reviewed hero pool, disable neutrals/runes, tune Turbo gold/XP, and make wards invulnerable.
5. Test real disconnect/reconnect behavior and pause with wall-clock timeout. Both disconnect before result => cancelled, no MMR.
6. Trigger losing Ancient destruction visuals, then call GameRules:SetGameWinner; verify standard post-game transition.
7. Add Panorama UI and secure backend only after verifying server-authoritative match identity and results. Never trust client-reported outcomes.
8. Test two real clients on the current Dota 2 build; publish Arcade version only after acceptance.

## Engine caveats
Pure Lua tests cannot verify Dota engine event payloads, timers, tower entity names, map layout, or Arcade server trust. Those require in-client integration testing.
