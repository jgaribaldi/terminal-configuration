-- [[ Core Autocommands ]]
-- Houses editor-wide autocmd definitions that apply to every session.

-- Highlight when yanking (copying) text.
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

return true
