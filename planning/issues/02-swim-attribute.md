## Goal
Add an explicit **Swim** attribute to NPCs and player characters. A character with Swim enabled can actively swim in liquids; with it disabled, it is still physically affected by water but cannot propel itself upward as a swimmer.

## Existing implementation
- `phys(e, mx, jp)` already computes `e.wet`, slows horizontal movement in liquid, applies water gravity, and applies upward propulsion on `jp` when wet.
- `npcAI()` triggers swimming-like jumps when an NPC is wet. `playerTick()` already selects the dedicated player **Swim** animation when wet.
- NPC persisted defaults are in `DNP`; player persisted defaults are in `DPP`. NPC toggles live in `NTOG`; player toggles in `PTOG`; `mkSpec()` and `spUI()` build/render controls.
- Runtime NPCs are created in `npcEnt()`; players initialize in `setPlayer()`.

## Requirements
- Add a boolean persisted field named `swim` to both NPC and Player definitions. Make it editable in their creator attribute UI. Coordinate its placement with the consolidated attribute-menu issue.
- Backward compatibility is critical: **default existing and missing `swim` values to enabled** so older creations keep their current water movement behavior. Newly created records may follow the same default initially.
- Set a runtime `canSwim` flag from the definition in `npcEnt()` and `setPlayer()`. Do not use the runtime name `sw` because `P0.sw`/`e.sw` already represent attack/swing timing.
- Keep liquid detection, drag, and gravity for every character. Only swimmers can apply active upward/swimming propulsion or NPC swim-navigation behavior. Non-swimmers should sink naturally and must not be granted an underwater jump workaround.
- NPC swim behavior should be functional, not purely cosmetic: swimmers can rise or navigate out of bodies of water using their existing AI, while non-swimmers do not repeatedly try swimming strokes.
- Preserve the existing `Swim` animation state for swimmers and choose a sensible non-swimmer falling/idle animation while submerged. No new sprite art is required.
- Do not change the global water material simulation, collision rules, regular ground jumps, flying, or fireproof handling.

## Suggested implementation touchpoints
`DNP`, `DPP`, `NTOG`, `PTOG`, `mig()`, `fixPc()`, `phys()`, `npcEnt()`, `setPlayer()`, `npcAI()`, `playerTick()`, `spUI()`.

## Acceptance criteria
- [ ] Swim is visible and editable for both NPCs and players; persists after save/reload.
- [ ] In water, an enabled player can swim upward with the existing jump/up control and uses the Swim state.
- [ ] In the same water, a disabled player cannot swim upward and sinks; normal land movement is unchanged.
- [ ] Swimming NPCs can navigate water; non-swimming NPCs do not use swim strokes.
- [ ] Built-in NPCs and pre-change saves keep their existing water behavior when `swim` is missing.
- [ ] Flying NPC behavior and ground-level jumps still work.
- [ ] No use of `sw` to store Swim capability, avoiding collision with swing animation timing.
