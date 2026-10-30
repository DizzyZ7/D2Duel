# Duel Pass Panorama preview

A static Panorama layout, stylesheet and script live under `content/panorama/`. This is a visual scaffold, not a mounted in-game screen. Dota 2 Workshop Tools must be used to validate paths, rendering, layout behavior and runtime compatibility.

The preview shows two reward tracks and a target price of USD 2. There is deliberately **no purchase button**: Valve must approve and enable official Custom Game Pass functionality first.

Next steps: mount the panel via the appropriate custom-game UI manifest, render it in Workshop Tools, connect server-authoritative progress and entitlement snapshots, add keyboard/controller focus, localization and accessibility, and test with two clients. Never allow Panorama to grant XP or premium ownership.
