---
name: nvim-config
description: Continue customizing this Neovim config (forked from kickstart.nvim) to the user's own daily stack — AI coding agent, autocomplete, more languages/LSPs, formatter choices, active colorscheme, anything else. Use when the user asks to set up or extend their Neovim config, add a language, wire in an AI agent, or change the colorscheme in this repo.
---

# Neovim config customization (this repo)

Assumes the environment is already set up (tools installed, repo placed at `~/.config/nvim`) — that's the root `CLAUDE.md`'s job, run it first if this is a fresh clone.

This repo is a fork of [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) using Neovim's native plugin manager (`vim.pack`, requires Neovim 0.12+) — not lazy.nvim. Everything lives in one `init.lua`, split into numbered `-- SECTION N` comment blocks, plus an extension point at `lua/custom/plugins/`. **Do not restructure this.** Add customization inside the existing sections (LSP servers table, `formatters_by_ft`, treesitter `parsers` list) or as a new file under `lua/custom/plugins/`, required from Section 10. Never introduce lazy.nvim, packer, or any other plugin manager — `vim.pack.add { gh 'owner/repo' }` is the only mechanism (the `gh()` helper is defined near the top of `init.lua` at the module scope; duplicate it locally in any new `lua/custom/plugins/*.lua` file since those are separate modules).

## Baseline already in this repo

- **LSP** (Section 6, `servers` table): `clangd` (C/C++), `pyright` + `ruff` (Python), `ts_ls` (TS/JS/React), `lua_ls`, `stylua`.
- **Formatting** (Section 7, conform.nvim `formatters_by_ft`): `prettierd`/`prettier` for JS/TS/JSX/TSX, `ruff_format` for Python, `clang_format` for C/C++.
- **Treesitter** (Section 9, `parsers` list): bash, c, cpp, javascript, typescript, tsx, python, lua, markdown, + kickstart defaults. Note: any other filetype auto-installs its parser on first open anyway (see the `FileType` autocmd in that section) — the list is just for pre-warming common ones.
- **Autocomplete**: `blink.cmp` (Section 8) — this is kickstart's own current default, not nvim-cmp. Keep it unless the user explicitly wants nvim-cmp instead (that would mean removing blink.cmp's `vim.pack.add`/`setup` in Section 8 and adding `hrsh7th/nvim-cmp` + sources in a new `lua/custom/plugins/cmp.lua` — a real swap, confirm before doing it).
- **Colorschemes**: `tokyonight-night` active by default (Section 2, kickstart's own choice — left as-is on purpose). Also installed but inactive, via `lua/custom/plugins/colorscheme.lua`: `catppuccin` (mocha flavour configured), `rose-pine`, and `cerne`/`cerne-light` (from [Cerne17/cerne.nvim](https://github.com/Cerne17/cerne.nvim), the user's own published brand colorscheme).
- **Which-key, Telescope**: fully wired in kickstart's own sections, untouched. New keymaps you add for new plugins should register under the existing which-key spec (Section: look for `require('which-key').setup` / the `spec` table), not a separate keymap system.
- **AI coding agent**: not set up yet — this is the main open item, see interview below.

## Interview the user before changing anything

Ask (don't assume — this skill has no opinion beyond keeping kickstart's structure):

1. **AI coding agent** to wire in: Claude Code (simplest: a terminal-toggle keymap `:vsplit | terminal claude`; tighter integration: `coder/claudecode.nvim` for diffs/inline apply), GitHub Copilot (`zbirenbaum/copilot.lua`, and if kept on blink.cmp, `giuxtaposition/blink-cmp-copilot` as a blink source), both, or none.
2. **Active colorscheme**: keep `tokyonight-night`, or switch the default to `catppuccin`, `rose-pine`, `cerne`, or `cerne-light`? (Switching = changing the `vim.cmd.colorscheme '...'` line in Section 2, or moving that call into `lua/custom/plugins/colorscheme.lua` if the user wants colorscheme choice centralized there instead — ask which they'd prefer, both are valid given kickstart's structure.)
3. **More languages/frameworks** beyond TS/JS/React, Python, C/C++? Get the LSP server name (mason-lspconfig name) and formatter for each before adding.
4. **Autocomplete**: confirmed staying on blink.cmp, or switch to nvim-cmp?
5. **Anything else in daily use**: a file tree (kickstart deliberately omits one — `stevearc/oil.nvim` is the natural fit), linter beyond what's LSP-provided (e.g. `mfussenegger/nvim-lint` — there's a commented-out `kickstart.plugins.lint` require in Section 10 already), tmux/dotfile integration, debug adapter (`kickstart.plugins.debug`, also already stubbed in Section 10), etc.

Record answers, then implement — don't re-ask mid-implementation unless something conflicts with what's already baseline.

## Adding a new language

1. Add the LSP server to the `servers` table in Section 6 (empty `{}` unless it needs settings). It's auto-added to `mason-tool-installer`'s `ensure_installed` since that list is built from `vim.tbl_keys(servers)`.
2. If it needs a formatter that isn't the LSP itself, add the mason package name to the `vim.list_extend(ensure_installed, {...})` call right after (same Section 6), and add the filetype → formatter mapping in Section 7's `formatters_by_ft`.
3. Add the treesitter parser name to the `parsers` list in Section 9 (optional — it'll auto-install on first file open regardless, this just pre-warms it).

## Adding a plugin (AI agent, file tree, etc.)

Create `lua/custom/plugins/<name>.lua`. Pattern:

```lua
local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'owner/repo' }
require('plugin_name').setup { ... }

-- keymaps here, registered under the existing which-key groups if relevant
```

Then require it explicitly from Section 10 of `init.lua` (next to the existing `require 'custom.plugins.colorscheme'` line) — explicit requires, not the `require 'custom.plugins'` bulk loader, since load order matters for anything that depends on another custom plugin.

## Switching the active colorscheme

Edit the `vim.cmd.colorscheme '...'` line in Section 2 of `init.lua` (currently `'tokyonight-night'`) — changing it to `'cerne'` or `'cerne-light'` works once `lua/custom/plugins/colorscheme.lua` has installed `Cerne17/cerne.nvim` (it already does). `:Telescope colorscheme` previews any of them live before committing to one.

## Verify after changes

```bash
nvim --headless "+lua vim.pack.get()" +qa   # sanity-check pack state loads without error
```
Then open nvim for real, open a file per changed/added language, and confirm: `:checkhealth`, `:LspInfo` shows the right server attached, `<leader>f` formats it (conform keymap, Section 7), completion menu appears while typing, `:Telescope colorscheme` shows the new schemes, `<leader>` shows which-key popup including any new groups you registered, and the AI agent keymap/plugin works as configured.

## Non-negotiables

- Single `init.lua` with numbered sections stays the shape of the config — no lazy.nvim, no splitting Section 6/7/9 into separate files.
- New plugins go in `lua/custom/plugins/`, one file per concern, required explicitly from Section 10.
- Never guess a plugin's GitHub URL the user didn't name or confirm.
- Ask before changing the default active colorscheme or swapping an already-working piece (e.g. blink.cmp → nvim-cmp) — those are opinionated changes, not additions.
