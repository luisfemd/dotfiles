vim.cmd [[
  let test#strategy = "neoterm"
  " Use unit_test instead test to avoid drop/create/migrate
  let test#elixir#exunit#executable = 'MIX_ENV=test mix unit_test'
]]

vim.keymap.set('n', '<leader>tt', ':TestNearest<CR>')
vim.keymap.set('n', '<leader>tf', ':TestFile<CR>')
vim.keymap.set('n', '<leader>tl', ':TestLast<CR>')

