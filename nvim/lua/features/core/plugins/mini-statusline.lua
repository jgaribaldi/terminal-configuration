local function configure_statusline()
  local statusline = require 'mini.statusline'
  statusline.setup { use_icons = vim.g.have_nerd_font }
  ---@diagnostic disable-next-line: duplicate-set-field
  statusline.section_location = function()
    return '%2l:%-2v'
  end
end

return {
  'echasnovski/mini.nvim',
  opts = function(_, opts)
    opts.handlers = opts.handlers or {}
    table.insert(opts.handlers, configure_statusline)
  end,
}
