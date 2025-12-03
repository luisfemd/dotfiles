vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.backspace = '2'
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.cursorline = true
vim.opt.autoread = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.expandtab = true
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.ruler = true
vim.opt.clipboard = "unnamedplus"

vim.cmd [[ set noswapfile ]]

-- disable unused providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0

-- keymaps
vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')
vim.keymap.set('n', 'SSA', ':wa<CR>:mksession! ~/.local/share/nvim/sessions/')
vim.keymap.set('n', 'SO', ':wa<CR>:so ~/.local/share/nvim/sessions/')

vim.keymap.set("n", "<leader>mf", ":MFT<CR>", { desc = "Mix Format file" })

