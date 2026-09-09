# Setting this repo up as someone's Neovim config

This repo is a fork of [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim), pre-loaded with a baseline (TS/JS/React, Python, C/C++ LSP+formatting; tokyonight/catppuccin/rose-pine/cerne colorschemes) and a `.claude/skills/nvim-config/SKILL.md` skill for continuing the customization to whoever's running it.

If someone just cloned this and asked you to finish the setup, run the steps below **in order**, without stopping to ask permission for the package-manager installs in Step 1 — installing the tools this config needs is exactly what this file authorizes. Do still ask before touching an existing `~/.config/nvim` in Step 2, and before anything destructive outside this scope.

## Step 1 — Preflight: verify required tools, install what's missing

Detect the OS (macOS / Debian-Ubuntu / Arch / Fedora / Windows) and check each row below. Install anything missing with the matching command, then re-check.

| Tool | Why | Check | macOS (brew) | Debian/Ubuntu (apt) | Arch (pacman) | Fedora (dnf) |
|---|---|---|---|---|---|---|
| git | clone/track this config | `git --version` | `brew install git` | `sudo apt install git` | `sudo pacman -S git` | `sudo dnf install git` |
| **Neovim 0.12+ with `vim.pack`** | this config's plugin manager is Neovim's native `vim.pack`, not lazy.nvim/packer — an older Neovim can't run it at all | `nvim --headless -c "lua io.write(tostring(vim.pack ~= nil))" -c "qa"` must print `true` | `brew install neovim` (or `brew upgrade neovim` if already installed but old) | apt's version is usually too old — install from a prebuilt tarball at https://github.com/neovim/neovim/releases (pick the asset matching the OS/arch) or `sudo add-apt-repository ppa:neovim-ppa/unstable && sudo apt update && sudo apt install neovim` | `sudo pacman -S neovim` (rolling release, usually current already) | `sudo dnf install neovim` (check version after; use the releases page above if too old) |
| ripgrep | Telescope live-grep | `rg --version` | `brew install ripgrep` | `sudo apt install ripgrep` | `sudo pacman -S ripgrep` | `sudo dnf install ripgrep` |
| fd | Telescope find-files (optional — falls back to `find` without it) | `fd --version` | `brew install fd` | `sudo apt install fd-find` (binary is `fdfind`) | `sudo pacman -S fd` | `sudo dnf install fd-find` |
| C compiler | Treesitter compiles parsers from source on first use | `cc --version` (or `gcc --version`) | `xcode-select --install` | `sudo apt install build-essential` | `sudo pacman -S base-devel` | `sudo dnf groupinstall "Development Tools"` |
| Node.js + npm | Mason installs `ts_ls`, `pyright`, `prettier`/`prettierd` via npm | `node --version && npm --version` | `brew install node` | `sudo apt install nodejs npm` | `sudo pacman -S nodejs npm` | `sudo dnf install nodejs` |
| curl/wget, tar, unzip | Mason's downloader/extractor | usually already present | install via the same package manager if any is missing | | | |

**Nerd Font** (JetBrainsMono Nerd Font or similar) is needed for icons to render correctly in Telescope/statusline/which-key, but it's a terminal-app setting, not something a repo or this agent can install into your terminal — ask the user if they have one set, and if not, tell them to install one and set it as their terminal's font manually. Don't try to detect or fix this yourself.

## Step 2 — Put this repo where Neovim expects it

Neovim looks for its config at `~/.config/nvim` (Linux/macOS) or `%LOCALAPPDATA%\nvim` (Windows). If the clone isn't already there:

- No existing config at that path: move the clone there (`mv <clone-dir> ~/.config/nvim`, or the Windows equivalent) — keep `.git` intact so it stays a working, pushable repo.
- A config already exists there: **stop and ask the user** whether to back it up (`mv ~/.config/nvim ~/.config/nvim.bak.$(date +%s)`) before moving this clone in. Never overwrite it silently.

## Step 3 — First boot

```sh
nvim --headless "+MasonToolsInstall" +qa
```

This kicks off the LSP/formatter downloads (`mason-tool-installer`, configured in `init.lua` Section 6) in the background — some may still be finishing when the command exits, since installs run as async jobs. Tell the user `:Mason` shows install status, and that opening a file in a new language triggers its own treesitter parser install automatically (`init.lua` Section 9) the first time.

## Step 4 — Interview the user and continue customizing

Load and follow `.claude/skills/nvim-config/SKILL.md` now — that's where the actual interview (AI coding agent, autocomplete, more languages/LSPs, active colorscheme, anything else) and the rules for extending this specific config live. Don't duplicate that logic here; this file only covers getting the environment ready to run it.

## Non-negotiables

- Single `init.lua`, numbered `-- SECTION N` blocks, `vim.pack` only — no lazy.nvim, no packer.
- New plugins go in `lua/custom/plugins/`, one file per concern (see the skill for the exact pattern).
- Never guess a plugin/colorscheme git URL the user didn't name.
