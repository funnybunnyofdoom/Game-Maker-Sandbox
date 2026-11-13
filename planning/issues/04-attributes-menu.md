## Goal
Reduce control clutter. Within each editor, move all **toggleable content attributes** into one clearly labeled **Attributes** selection menu/panel, rather than scattering individual on/off buttons around its tools.

## Existing implementation
- NPC and Player Creator currently expose toggles directly through `mkSpec()` / `spUI()`, using `NTOG` (`Fly`, `Fireproof`) and `PTOG` (`Fireproof`). Item Creator uses `ITOG` (`Two-handed`, `Stackable`). Swim will be added under another issue.
- Material Editor `buildMat()` and `mui()` directly render `Flammable`, `Support`, and enabled transformation flags (`Freeze`, `Melt`, `Precip`, `Boil`). Solid/Liquid/Gas is a mutually exclusive material state, not a set of three independent booleans.
- Structure Builder directly exposes `Map transition` (`strTr`) and `Container` (`strCont`) as content flags.
- Map, World and other editor screens also have **editor-mode controls** such as simulation, draw/line/fill, link doors, playback, mount placement and frame activation. Distinguish these from saved object properties; do not accidentally bury fundamental tools or turn them into persisted attributes.

## Requirements
- Provide a consistent **Attributes** entry in each relevant editor's controls. Clicking opens a compact selection menu/panel containing that editor's content toggles, with visible enabled/disabled state and accessible labels.
- **NPC Creator**: Fly, Fireproof, Swim (after the Swim issue); **Player Creator**: Fireproof, Swim; **Item Creator**: Two-handed, Stackable; **Structure Builder**: Map transition, Container; **Material Editor**: Flammable, Support and the enable/disable switch for each temperature transformation. Allow the transformation target/temperature fields to remain in the detailed material editor unless moving them improves usability.
- For Material Editor, keep Solid/Liquid/Gas clearly mutually exclusive. If moved into Attributes, use a single state selector rather than three independent checkboxes.
- For Map Builder and World Builder, use the same entry only for real content attributes that exist. If none exist, do not invent persisted attributes. Preserve separate controls for drawing and authoring modes such as simulation, placement, door linking and zoom.
- The unified menu should work on both desktop and touch, not obscure core canvas editing, and reflect current saved/draft values immediately.
- Remove redundant per-attribute buttons from editor toolbars after migration; do not duplicate controls in two places.
- Keep existing saved property names and value types. The menu is a UI refactor, not a save schema rewrite; old saves must retain their behavior.
- Avoid introducing new attribute classifications or renaming existing mechanics beyond what is required by this issue.

## Suggested implementation touchpoints
`mkSpec()`, `spUI()`, `NTOG`, `PTOG`, `ITOG`, `buildMat()`, `mui()`, `#trb`, `#cnb`, `enter()`, `enterWorld()`, `trays()`, and editor toolbar layout/CSS.

## Acceptance criteria
- [ ] Each existing toggleable content attribute for NPC, Player, Item, Structure and Material is available in one Attributes menu for that editor.
- [ ] Swim appears there when the Swim issue is implemented.
- [ ] Toggling from the menu immediately updates its draft, saves and reloads correctly, and works on old records.
- [ ] Existing top-level editor tools (drawing, animation playback, Mount placement, zoom, door linking, Sim) remain operational and appropriately placed.
- [ ] Material transform flags still respect first-match precedence and retain thresholds and targets.
- [ ] Menu is keyboard accessible and touch friendly; states are clearly legible in both light/dark themes.
- [ ] Every creator, builder and Material Editor still saves/loads the same data and retains its non-attribute functionality.
