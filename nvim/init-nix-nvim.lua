-- ============== core =================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.smartindent = true
opt.clipboard = "unnamedplus"
opt.splitright = true
opt.splitbelow = true
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true
opt.number = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.wrap = true
opt.linebreak = true
opt.breakindent = true
opt.list = false
opt.listchars = {
  tab = "→ ", lead = "·", space = "·", trail = "·",
  extends = "⟩", precedes = "⟨", nbsp = "⊙", eol = "↲",
}

-- ============== keymaps ==============
local map = vim.keymap.set
local nore = { noremap = true, silent = true }

map("n", "<Esc><Esc>", ":nohlsearch<CR>", nore)
map("n", "<C-s>", ":w<CR>", nore)
map("i", "<C-s>", "<C-o>:w<CR>", nore)
map("v", "<C-c>", '"+y', { desc = "Copy to system clipboard" })
map("n", "<C-v>", ':set paste<CR>"+p:set nopaste<CR>', { desc = "Paste clipboard (normal)" })
map("i", "<C-v>", '<C-o>:set paste<CR><C-r>+<C-o>:set nopaste<CR>', { desc = "Paste clipboard (insert)" })
map("v", "<BS>", "d", { desc = "Delete in visual mode" })
map("n", "<Down>", "gj")
map("n", "<Up>", "gk")
map("n", "<Tab>", ":bnext<CR>", nore)
map("n", "<S-Tab>", ":bprev<CR>", nore)
map("n", "<leader>l", ":set list!<CR>", nore)

local function smart_delete()
  local line = vim.fn.getline(".")
  local col  = vim.fn.col(".")
  local len  = #line
  if line:match("^%s*$") then return "dd" end
  return (col == 1 or col == len) and "i<BS><Esc>" or "i<BS><Esc>l"
end
local function smart_return() return "i<CR><Esc>" end
map('n','<BS>',function()
  local keys = smart_delete()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys,true,false,true),'n',false)
end)
map('n','<CR>',function()
  local keys = smart_return()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys,true,false,true),'n',false)
end)



-- ============== colorscheme ==========
pcall(vim.cmd, "colorscheme catppuccin")

-- ============== autocomplete ==========
-- nicer popup behavior for the built-in completion menu
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- map <C-Space> to keyword completion (buffer words)
vim.keymap.set("i", "<C-Space>", "<C-x><C-n>", { desc = "Keyword completion" })

-- optional: <A-f> for file path completion
vim.keymap.set("i", "<A-f>", "<C-x><C-f>", { desc = "Path completion" })

-- ============== auto-close =================

-- Auto close tags in webby filetypes
vim.g.closetag_filetypes = 'html,xhtml,phtml,xml,jsx,javascript,typescript,javascriptreact,typescriptreact,svelte,vue'
vim.g.closetag_xhtml_files = 'xhtml,jsx,javascriptreact,tsx,typescriptreact'
vim.g.closetag_regions = {
  ['typescript.tsx'] = 'jsxRegion,tsxRegion',
  ['javascript.jsx'] = 'jsxRegion',
  ['typescriptreact'] = 'jsxRegion,tsxRegion',
  ['javascriptreact'] = 'jsxRegion',
}

-- ============== plugins (Nix provides them) ==============

-- which-key
pcall(function()
  require("which-key").setup()
end)

-- nvim-hlslens
pcall(function() require("hlslens").setup() end)

-- telescope
pcall(function()
  local tb = require("telescope.builtin")
  map("n", "<leader>ff", tb.find_files, { desc = "Find files" })
  map("n", "<leader>fg", tb.live_grep, { desc = "Live grep (ripgrep)" })
  map("n", "<leader>fb", tb.buffers, { desc = "Buffers" })
  map("n", "<leader>fh", tb.help_tags, { desc = "Help tags" })
end)

-- comment
pcall(function()
  require("Comment").setup()
end)

-- surround
pcall(function()
  require("nvim-surround").setup()
end)

-- autopairs
pcall(function()
  require("nvim-autopairs").setup()
end)

-- ts-autotag (for HTML/TSX)
pcall(function()
  require("nvim-ts-autotag").setup()
end)

-- gitsigns
pcall(function()
  require("gitsigns").setup()
end)

-- lualine
pcall(function()
  require("lualine").setup()
end)

-- nvim-tree
pcall(function()
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
  require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = { width = 30 },
    renderer = { group_empty = true },
    filters = { dotfiles = true },
  })
  map("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file tree" })
end)

-- leap
pcall(function()
  require("leap").add_default_mappings()
end)

-- scrollbar
pcall(function()
  require("scrollbar").setup({
    show = true,
    handlers = { diagnostic = true, search = true },
  })
end)

-- tagalong
-- Defaults are usually fine; enable broadly
vim.g.tagalong_filetypes = {
  'html','xhtml','xml','svelte','vue',
  'javascript','javascriptreact','typescript','typescriptreact'
}
