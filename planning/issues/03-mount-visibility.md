## Goal
Add a **Show/Hide mount points** control to the sprite editor so creators can view pixel art without mount markers obstructing it.

## Existing implementation
- Both NPC and player sprites use `MP`, a four-slot (`Hand`, `Off hand`, `Head`, `Back`) by three-frame mount-point grid.
- `#mnt` toggles mount-placement mode (`pm`), `#msl` cycles slots, and `renderSp()` always draws existing mount point markers when animation preview is off.
- Item Creator has an independent grip-point marker (`GP`) controlled by `#igp`; it is not the NPC/player mount-point grid.

## Requirements
- Add a discoverable Show/Hide mount-points button in NPC and Player Creators, close to the existing Mount tool.
- Show controls **visibility only**. Never remove coordinates or modify `MP`, save data, items or equipped mounts.
- Default new editor sessions to **visible** so current behavior is preserved. Preserve visibility while switching frames, slots and animation states within an editor session.
- Hide the markers in `renderSp()` when the setting is off, including all four mount slots. The pixel artwork and preview rendering must remain unchanged.
- Placement mode and marker visibility must be clearly distinguishable: hiding markers cannot silently erase an existing point, and the user must still be able to turn markers back on before relocating them.
- Work with both mouse and touch; use an accessible button label and an obvious active state.
- Item Creator's grip point is out of scope unless the same approach can be reused safely without changing grip behavior.

## Suggested implementation touchpoints
`#nb`, `#mnt`, `pm`, `MP`, `renderSp()`, `spUI()`, `enter()`, and per-state frame navigation.

## Acceptance criteria
- [ ] All NPC/Player mount markers disappear when hidden and return to precisely their previous locations when shown.
- [ ] Hiding markers does not change mount data or equipped item placement in play mode.
- [ ] Toggle state remains stable during frame and player animation-state switching.
- [ ] New editor sessions display mount points by default.
- [ ] Existing NPCs and player characters can be opened, edited, saved and reloaded without mount loss.
- [ ] Touch controls and accessibility labels are supported.
