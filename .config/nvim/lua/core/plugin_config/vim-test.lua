vim.cmd [[
  let test#strategy = "neoterm"
]]

vim.keymap.set('n', '<leader>tt', ':TestNearest<CR>')
vim.keymap.set('n', '<leader>tf', ':TestFile<CR>')
vim.keymap.set('n', '<leader>tl', ':TestLast<CR>')

