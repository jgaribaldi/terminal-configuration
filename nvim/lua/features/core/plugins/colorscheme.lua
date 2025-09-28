return {
  'folke/tokyonight.nvim',
  priority = 1000,
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require('tokyonight').setup {
      styles = {
        comments = { italic = false },
      },
      on_colors = function(colors) -- keep hook available for future tweaks
        -- colors.fg_gutter = '#9999ff'
      end,
    }

    vim.cmd.colorscheme 'tokyonight-night'
  end,
}
