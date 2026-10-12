# pi

Dotfiles for the [pi coding agent](https://pi.coding.agent).

## Two kinds of files, two deployment strategies

pi's config lives under `~/.pi/agent/`, but not all of it behaves the same way.
This package splits files by **who writes them**:

### 1. Immutable files you author → deployed by GNU Stow

Files pi **only reads**, never rewrites. Safe to symlink; `stow pi` deploys them.

Examples (add when you adopt them):
- `keybindings.json` — custom keybindings
- `models.json` — custom model definitions
- `AGENTS.md` / `SYSTEM.md` — global agent instructions
- `prompts/*.md` — prompt templates
- `skills/*/SKILL.md` — custom skills
- `themes/*.json` — custom themes
- `extensions/*.ts` — hand-written extensions (NOT npm-installed ones)

These mirror the target tree under `.pi/agent/` and are stowed normally.

### 2. Mutable files pi (or its extensions) rewrite → synced, NOT symlinked

pi and its extensions write these with **atomic rename** (`write tmp` + `rename`),
which silently replaces any symlink with a real file. So they must be real files
on both sides and kept in sync by copying.

- `.pi/agent/settings.json` — pi rewrites this on `/settings` and on package
  install/uninstall (the `packages` array is pi's source of truth for which
  extensions are installed).
- `.pi/agent/extensions/pi-rtk-optimizer/config.json` — the rtk-optimizer
  extension rewrites this via its config modal
  (`node_modules/pi-rtk-optimizer/src/config-store.ts :: saveRtkIntegrationConfig`).

These are kept out of stow via path-anchored `--ignore` rules in
`../.stowrc`, and managed by **`sync.nu`** instead.

## Usage

```sh
# After cloning dotfiles on a new machine:
stow pi                              # deploy any immutable files (keybindings, etc.)
nu ~/.dotfiles/pi/sync.nu push       # restore canonical settings.json + ext configs

# Day-to-day, after changing settings in pi or via /settings:
nu ~/.dotfiles/pi/sync.nu status     # see which side is newer
nu ~/.dotfiles/pi/sync.nu diff       # inspect differences
nu ~/.dotfiles/pi/sync.nu pull       # save live state into dotfiles
# then: git -C ~/.dotfiles add pi && git commit
```

Add a new mutable file by appending its path (relative to the agent root) to the
`files` list in `sync.nu`. Add a new immutable file by just creating it under
`.pi/agent/` and running `stow pi` — no other changes needed.

## What is explicitly NOT versioned

Secrets and runtime state, all machine-local:
- `auth.json` (API keys / OAuth tokens)
- `trust.json` (per-folder project trust decisions)
- `sessions/` (conversation history)
- `logs/`, `pi-debug.log`
- `npm/` (extension package cache — derived from `settings.json`'s `packages`)
- `git/`, `projects-memory/`, `pi-hermes-memory/*.db*`
- `providers/*/device_id` (machine-bound device IDs)
