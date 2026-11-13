## Goal
In **Player Creator**, let the user select an existing NPC definition and turn it into a new, editable player character without touching or converting away the source NPC.

## Existing implementation
- `npcs` is populated by `loadNpcs()`, including built-in villagers and custom NPCs; an NPC has `fr` (three sprite frames), `act`, `mp`, dimensions, name and behavior data.
- Player characters are stored in `pcs` via `savePc()` and contain `st`: five animation states (`PST = ['Idle','Walk','Jump','Swim','Attack']`), with three frames and mount points per state.
- The Player Creator is `mode === 'npc'` and `ek === 'pc'`; it currently opens a blank new character using `pcReset()` or existing player records using `loadPc()`.

## Requirements
- Add a clear **From NPC** action within Player Creator that opens a searchable or scrollable list of built-in and user-created NPC definitions (with names and, ideally, sprite thumbnails).
- Selecting an NPC creates a **new draft player character**, never a reference to mutable NPC data. Keep NPCs available in NPC Creator and map placement.
- Copy name (editable), sprite dimensions, all three source animation frames and active-frame flags; copy/clone per-frame mount points (do not share arrays).
- Map the NPC's active frames into the player's **Walk** state. Populate **Idle** from an appropriate existing active frame, and initialize **Jump**, **Swim**, and **Attack** with safe editable fallback frames; do not fabricate new art. Reuse mount points consistently in each initialized state.
- Initialize player-only defaults (health, speed, jump, inventory, FPS, respawn rule, fireproof, future Swim attribute, starting items) using `DPP`; do not silently copy NPC-only behavior or loot.
- If an unsaved player draft has changes, confirm before replacing it.
- Save through the existing `savePc()` path with a **new unique player ID** and `psb.pcs` storage. The newly created player must be selectable as the default (`Use as player`) and from World Builder's character selection.
- Preserve current NPC creation, direct Player Creator creation, load/edit of existing players and save compatibility.

## Suggested implementation touchpoints
`trays()`, `pcReset()`, `loadNpc()`, `loadPc()`, `savePc()`, `PST`, `DPP`, `PC.st`, `npcs`, `pcs`, and the editor's selection UI.

## Acceptance criteria
- [ ] Selecting a built-in or custom NPC creates an editable new player draft with recognizable pixels and correct dimensions.
- [ ] Existing active NPC frames become walk frames; the other four states are usable and can be customized independently.
- [ ] Changing pixels, mount points, or name in the new player never changes the source NPC.
- [ ] Saving adds exactly one independent player record and does not overwrite an NPC or existing player.
- [ ] The converted player is playable, equipable, and selectable globally and in World Builder.
- [ ] An existing old save with NPCs/players still loads unchanged.
- [ ] Mouse and touch interactions work; unsaved changes are protected.
