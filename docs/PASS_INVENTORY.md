# Cosmetic loadout architecture

The pure Lua `core.pass_loadout` module supports cosmetic equip, unequip and sanitization against an explicit ownership set. It never grants items and never changes gameplay rules.

## Trust boundary
- Client/UI requests are untrusted. Server must fetch authoritative ownership and season entitlement.
- Inventory must distinguish permanently claimed cosmetics from time-limited premium access; the latter follows Valve-approved Custom Game Pass rules if approved.
- Persist equipped cosmetics by SteamID and slot; sanitize again when loading and when entitlement expires.
- Reject arbitrary particle paths or asset identifiers from clients: only catalogued IDs are allowed.
- Rate-limit equip requests and keep visual toggles local to each viewer.
- No inventory database, Valve entitlement lookup, Panorama UI, or effects are wired yet.

## Slots
`emblem`, `profile_frame`, `title`, `spawn_effect`, `profile_banner`, `victory_effect`, `kill_announcement`, `hero_aura`.

This is a foundation for later two-client testing, not a live paid item system.
