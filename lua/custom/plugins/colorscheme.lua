-- Extra colorschemes, installed alongside kickstart's default (tokyonight,
-- set active in init.lua Section 2). None of these are activated here —
-- switch with `:colorscheme <name>` or set one active via
-- `vim.cmd.colorscheme(...)` in this file.
--
-- Available after this file loads:
--   tokyonight-night   (kickstart default, active)
--   catppuccin         (:colorscheme catppuccin / catppuccin-mocha / -latte / -frappe / -macchiato)
--   rose-pine          (:colorscheme rose-pine / rose-pine-moon / rose-pine-dawn)
--   cerne, cerne-light (:colorscheme cerne / cerne-light — from Cerne17/cerne.nvim, see github.com/Cerne17/cerne.nvim)

local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add {
  gh 'catppuccin/nvim',
  gh 'rose-pine/neovim',
  gh 'Cerne17/cerne.nvim',
}

require('catppuccin').setup { flavour = 'mocha' }
require('rose-pine').setup {}
