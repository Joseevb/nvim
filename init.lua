-- Create an augroup for highlight_yank
local highlight_yank_group = vim.api.nvim_create_augroup('highlight_yank', {})

-- Define the autocmd within the augroup
vim.api.nvim_create_autocmd('TextYankPost', {
  group = highlight_yank_group,
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 })
  end,
})

-- Create an augroup for prettier
local prettier_group = vim.api.nvim_create_augroup('Prettier', {})

-- Define the autocmd within the augroup
vim.api.nvim_create_autocmd('BufWritePost', {
  group = prettier_group,
  pattern = '*',
  command = 'Prettier'
})

vim.o.foldmethod = 'indent'

require("jose")
