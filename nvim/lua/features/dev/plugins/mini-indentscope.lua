return {
  {
    'echasnovski/mini.nvim',
    opts = function(_, opts)
      opts.handlers = opts.handlers or {}
      table.insert(opts.handlers, function()
        require('mini.indentscope').setup {
          symbol = '│',
          options = { try_as_border = true },
        }
      end)
    end,
  },
}
