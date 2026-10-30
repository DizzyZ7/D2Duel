# No automatic pauses during a duel

The live addon disconnect and reconnect handlers no longer call SetGamePaused. During an active match the opponent continues playing, including possible hero kills and mid-T1 destruction. A disconnected player has 60 real seconds to return; after that a forfeit can apply if the match has not already finished. This is a deliberate competitive rule.

A 60-second pre-match readiness window is represented by pure Lua `core/start_readiness.lua`. If both players are connected before the deadline it returns ready immediately; otherwise it cancels without MMR. **This module is not yet wired into the Dota engine.** The existing fixed 10-second pregame remains in the addon. Never advertise the 60-second readiness behavior as live until engine integration and two-client tests pass.

A near-simultaneous dual disconnect within five seconds is a suspected common outage; if both remain offline after the grace period the match cancels without MMR. Existing server-side results and rating persistence remain incomplete. Engine scheduling, abandon event reliability, server outages and native player pause controls require validation.
