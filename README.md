# Game Maker Sandbox

A browser-based pixel sandbox, material simulator and game-making toolkit. This repository starts with the complete **Pixel Sandbox 0.2** single-file HTML build, renamed **Game Maker Sandbox** without changing its gameplay behavior or saved-data keys.

## Start

Open `index.html` in a modern desktop or mobile browser. No build step is required. The app uses Canvas and browser `localStorage` and loads the optional pixel font from Google Fonts. The game runs without a server, although a local static server can be useful for testing.

On Windows, for a quick local HTTP server (with Python installed), run from this folder:

```powershell
py -m http.server 8080
```

Then visit `http://localhost:8080/`.

## Existing features

- Sand, liquids, gases, structural gravity and thermal material transformations
- Map Builder, Structure Builder, NPC Creator, Player Creator, Item Creator, Material Editor and World Builder
- Multiple frames and mount points for NPC and player sprites, five player animation states, equipment, combat and inventory
- NPC behavior, map transitions, persistent browser save data and world connections
- Touch and keyboard controls

## Key implementation notes

The baseline is **one HTML file**, with CSS and JavaScript inline. This is intentional: keep the initial import functional before considering any refactor. Existing persistence keys such as `psb.npcs`, `psb.pcs`, `psb.maps`, `psb.worlds`, `psb.items` and `psb.defpc` are **not renamed**. Changing them would hide users' existing browser saves. New schema fields should have backwards-compatible defaults.

Character data differs: NPCs store a three-frame `fr` array; player characters store five named animation states (`Idle`, `Walk`, `Jump`, `Swim`, `Attack`) each with up to three frames. NPC and player mount-point arrays already exist. Basic wet/swimming physics already run for both entity types; the requested Swim attribute makes the behavior configurable.

## Roadmap: first four issues

1. Create a player character from an existing NPC (`planning/issues/01-npc-to-player.md`)
2. Add a Swim capability attribute to NPCs and players (`planning/issues/02-swim-attribute.md`)
3. Add a hide/show control for mount point overlays (`planning/issues/03-mount-visibility.md`)
4. Consolidate toggleable attributes into one attributes menu per editor (`planning/issues/04-attributes-menu.md`)

Issue 2 should be considered when designing issue 4 so Swim appears in the consolidated menu. The issue bodies are included in this repository and the setup script posts them to GitHub.

## GitHub setup (Windows)

Requires Git and GitHub CLI. Sign in first:

```powershell
gh auth login
```

If you want the script to create/link a GitHub Projects board, also enable its scope:

```powershell
gh auth refresh -s project
```

From an extracted copy of this folder:

```powershell
powershell -ExecutionPolicy Bypass -File .\setup-github.ps1
```

It creates the **private** `funnybunnyofdoom/Game-Maker-Sandbox` repository, pushes the project, creates the four issues, then attempts to create/link a GitHub Project board named **Game Maker Sandbox**. The script checks existing issues to avoid creating duplicates on reruns. You can change the repository visibility on GitHub later if you want to publish the source.

## Connecting development in ChatGPT

After the repo exists, ensure the GitHub connection has access to `funnybunnyofdoom/Game-Maker-Sandbox`. In this ChatGPT project, reference the repository when asking for issue reviews or code changes. The repository is the source of truth; the ZIP is only the initial bootstrap snapshot.

## Attribution and licensing

No license has been added automatically. The repository remains private initially; choose a license explicitly if you decide to distribute the source.
