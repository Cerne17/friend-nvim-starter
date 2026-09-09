-- cerne.pro brand colorscheme ("sapwood", light)
-- Tokens from ~/Documents/design-guidelines. Per the guidelines' own note,
-- amber (heartwood) fails contrast on light backgrounds, so oxblood stands
-- in as the accent/keyword/link color throughout — this is not a
-- workaround, it's the documented light-theme design. `c.info` is a
-- darkened tint of the dark theme's blue (needs to go dark-on-light
-- instead of light-on-dark); everything else reuses brand tokens
-- directly, all independently verified >=4.5:1 against ink.
--
-- Same structural fixes as colors/cerne.lua: readable ghost text, visible
-- float borders (oxblood, since that's this theme's accent), and a real
-- background block (oxblood + near-white text) for completion/Telescope
-- selection rather than a same-as-background wash.

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end
vim.o.termguicolors = true
vim.o.background = "light"
vim.g.colors_name = "cerne-light"

local c = {
  ink = "#ECEBE6",
  surface = "#F5F4F0",
  surface2 = "#D8D5CC",
  text = "#1A1B1E",
  text_muted = "#5A5852",
  accent = "#8C3B24", -- heartwood/heartwood-glow/oxblood all collapse to this on light
  sapwood = "#3A6E52",
  info = "#526D89", -- darkened tint of the dark theme's blue, 4.5:1 vs light ink
}

local hl = vim.api.nvim_set_hl

local groups = {
  -- Editor UI
  Normal = { fg = c.text, bg = c.ink },
  NormalFloat = { fg = c.text, bg = c.surface },
  FloatBorder = { fg = c.accent, bg = c.surface },
  FloatTitle = { fg = c.accent, bg = c.surface, bold = true },
  CursorLine = { bg = c.surface },
  CursorLineNr = { fg = c.accent, bold = true },
  LineNr = { fg = c.text_muted },
  Visual = { bg = c.surface2 },
  Search = { fg = c.ink, bg = c.accent },
  IncSearch = { fg = c.ink, bg = c.accent, bold = true },
  CurSearch = { fg = c.ink, bg = c.accent, bold = true },
  Pmenu = { fg = c.text, bg = c.surface },
  PmenuSel = { fg = c.ink, bg = c.accent, bold = true },
  PmenuSbar = { bg = c.surface2 },
  PmenuThumb = { bg = c.accent },
  StatusLine = { fg = c.text, bg = c.surface },
  StatusLineNC = { fg = c.text_muted, bg = c.surface },
  WinSeparator = { fg = c.surface2 },
  VertSplit = { fg = c.surface2 },
  Folded = { fg = c.text_muted, bg = c.surface },
  SignColumn = { bg = c.ink },
  ColorColumn = { bg = c.surface },
  NonText = { fg = c.surface2 },
  EndOfBuffer = { fg = c.surface2 },
  Whitespace = { fg = c.surface2 },
  MatchParen = { fg = c.ink, bg = c.accent, bold = true },
  Title = { fg = c.accent, bold = true },
  Directory = { fg = c.accent },
  ErrorMsg = { fg = c.accent, bold = true },
  WarningMsg = { fg = c.accent },
  ModeMsg = { fg = c.sapwood },
  MoreMsg = { fg = c.sapwood },
  Question = { fg = c.sapwood },
  WildMenu = { fg = c.ink, bg = c.accent },

  -- Syntax
  Comment = { fg = c.text_muted, italic = true },
  Constant = { fg = c.sapwood },
  String = { fg = c.sapwood },
  Character = { fg = c.sapwood },
  Number = { fg = c.sapwood },
  Boolean = { fg = c.sapwood },
  Float = { fg = c.sapwood },
  Identifier = { fg = c.text },
  Function = { fg = c.accent, bold = true },
  Statement = { fg = c.accent },
  Conditional = { fg = c.accent },
  Repeat = { fg = c.accent },
  Label = { fg = c.accent },
  Exception = { fg = c.accent },
  Keyword = { fg = c.accent },
  Operator = { fg = c.text_muted },
  PreProc = { fg = c.accent },
  Include = { fg = c.accent },
  Define = { fg = c.accent },
  Macro = { fg = c.accent },
  PreCondit = { fg = c.accent },
  Type = { fg = c.text, bold = true },
  StorageClass = { fg = c.text, bold = true },
  Structure = { fg = c.text, bold = true },
  Typedef = { fg = c.text, bold = true },
  Special = { fg = c.sapwood },
  SpecialChar = { fg = c.sapwood },
  Tag = { fg = c.sapwood },
  Delimiter = { fg = c.text_muted },
  SpecialComment = { fg = c.text_muted, italic = true },
  Debug = { fg = c.accent },
  Underlined = { fg = c.accent, underline = true },
  Ignore = { fg = c.surface2 },
  Error = { fg = c.ink, bg = c.accent, bold = true },
  Todo = { fg = c.ink, bg = c.accent, bold = true },

  -- Diagnostics
  DiagnosticError = { fg = c.accent },
  DiagnosticWarn = { fg = c.accent },
  DiagnosticInfo = { fg = c.info },
  DiagnosticHint = { fg = c.sapwood },
  DiagnosticUnderlineError = { undercurl = true, sp = c.accent },
  DiagnosticUnderlineWarn = { undercurl = true, sp = c.accent },
  DiagnosticUnderlineInfo = { undercurl = true, sp = c.info },
  DiagnosticUnderlineHint = { undercurl = true, sp = c.sapwood },
  LspReferenceText = { bg = c.surface2 },
  LspReferenceRead = { bg = c.surface2 },
  LspReferenceWrite = { bg = c.surface2 },
  LspInlayHint = { fg = c.text_muted, bg = c.surface, italic = true },

  -- gitsigns.nvim
  GitSignsAdd = { fg = c.sapwood },
  GitSignsChange = { fg = c.accent },
  GitSignsDelete = { fg = c.accent },
  GitSignsCurrentLineBlame = { fg = c.text_muted, italic = true },

  -- Telescope
  TelescopeNormal = { fg = c.text, bg = c.surface },
  TelescopeBorder = { fg = c.accent, bg = c.surface },
  TelescopePromptNormal = { fg = c.text, bg = c.surface },
  TelescopePromptBorder = { fg = c.accent, bg = c.surface },
  TelescopePromptTitle = { fg = c.ink, bg = c.accent, bold = true },
  TelescopePreviewTitle = { fg = c.ink, bg = c.sapwood, bold = true },
  TelescopeResultsTitle = { fg = c.ink, bg = c.text_muted, bold = true },
  TelescopeSelection = { fg = c.ink, bg = c.accent, bold = true },
  -- No fg override: fg=accent here would be invisible against the
  -- accent-colored TelescopeSelection background (1:1, identical color).
  TelescopeMatching = { bold = true, underline = true },

  -- which-key
  WhichKey = { fg = c.accent, bold = true },
  WhichKeyGroup = { fg = c.sapwood },
  WhichKeyDesc = { fg = c.text },
  WhichKeySeparator = { fg = c.text_muted },
  WhichKeyFloat = { bg = c.surface },
  WhichKeyBorder = { fg = c.accent, bg = c.surface },

  -- blink.cmp
  BlinkCmpMenu = { fg = c.text, bg = c.surface },
  BlinkCmpMenuBorder = { fg = c.accent, bg = c.surface },
  BlinkCmpMenuSelection = { fg = c.ink, bg = c.accent, bold = true },
  BlinkCmpDoc = { fg = c.text, bg = c.surface },
  BlinkCmpDocBorder = { fg = c.accent, bg = c.surface },
  -- No fg override: inherits the row's own text color (dark on unselected,
  -- near-white on the oxblood-selected row) so it's legible on both.
  BlinkCmpLabelMatch = { bold = true },
  BlinkCmpGhostText = { fg = c.text_muted, italic = true },
  BlinkCmpSignatureHelp = { fg = c.text, bg = c.surface },
  BlinkCmpSignatureHelpBorder = { fg = c.accent, bg = c.surface },

  -- oil.nvim (directories/files render through Directory/Normal already)
  OilDir = { fg = c.accent, bold = true },

  -- Snacks dashboard (config/autocmds.lua only brands third-party
  -- colorschemes — these are owned here so cerne-light's dashboard is
  -- correct on its own, without depending on that fallback)
  SnacksDashboardHeader = { fg = c.accent, bold = true },
  SnacksDashboardDesc = { fg = c.text },
  SnacksDashboardKey = { fg = c.accent, bold = true },
  SnacksDashboardIcon = { fg = c.sapwood },
  SnacksDashboardFooter = { fg = c.text_muted, italic = true },
  SnacksDashboardSpecial = { fg = c.accent },
}

for group, opts in pairs(groups) do
  hl(0, group, opts)
end
