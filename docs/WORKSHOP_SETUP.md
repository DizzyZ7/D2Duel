# Local Workshop Tools integration checklist

This repository is a source scaffold, **not** an installable or published Dota 2 addon yet.

1. Install Dota 2 Workshop Tools through Steam and create an addon named `d2duel`.
2. Copy `game/scripts/vscripts/` into the addon game directory, retaining the directory structure.
3. Use Hammer to create a minimal mid-only map with correct Radiant/Dire spawns, lane pathing, towers, and Ancients. Map files are not included yet.
4. Configure addon metadata and game mode settings in the Workshop Tools project.
5. Verify the Lua addon entrypoint loads and emits no console errors.
6. Test with two clients: hero selection, death event, tower identity, timer, pause, reconnect, and game-over transition.
7. Only then enable hero randomization, creep/rune restrictions, Turbo economy, and ward protections. These are **not implemented** in the engine yet.
8. Do not enable public ranked persistence until the server authority and result authenticity are verified.

Known limitations: both-player disconnect currently sets cancelled state but does not yet close the Dota session; no Ancient destruction animation is guaranteed. The reconnect grace timer is only a configuration target. All engine APIs/events must be validated against the current game build.
