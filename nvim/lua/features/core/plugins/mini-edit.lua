local function configure_edit_modules()
  require('mini.ai').setup { n_lines = 500 }
  require('mini.surround').setup()
end

return {
  'echasnovski/mini.nvim',
  opts = {
    handlers = {
      configure_edit_modules,
    },
  },
  config = function(_, opts)
    for _, handler in ipairs(opts.handlers or {}) do
      handler()
    end
  end,
}
