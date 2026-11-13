# Game Maker Sandbox: agent development instructions

- Keep this project recognizably the same game. The initial baseline is `index.html`, a complete single-file HTML/CSS/JavaScript app.
- Make only changes required by the active issue; preserve all other controls, mechanics, names, art and functionality.
- Preserve `psb.*` `localStorage` keys, existing IDs, save-data compatibility and the single-file run path unless a migration is explicitly planned. Default new saved properties for older records.
- Protect both mouse/keyboard and touch interactions.
- Validate old saves and newly created NPC, player, item, material, map, structure and world records after edits.
- All editor state transitions must preserve unsaved edits or ask before destructive replacement.
- Keep data changes separate from visual-only changes, particularly the mount point visibility toggle.
- For new features, update related issue acceptance criteria, add repeatable manual tests, and report any untested paths.
- Source landmarks: `mkSpec`, `spUI`, `trays`, `pcReset`, `loadPc`, `loadNpc`, `savePc`, `saveSp`, `phys`, `npcAI`, `setPlayer`, `renderSp`, `buildMat`, `mui`, `enterWorld`.
