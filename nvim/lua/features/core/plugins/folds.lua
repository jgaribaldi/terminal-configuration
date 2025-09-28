return {
  'kevinhwang91/nvim-ufo',
  dependencies = {
    'kevinhwang91/promise-async',
  },
  event = 'BufReadPost',
  config = function()
    vim.opt.foldcolumn = '1'
    vim.opt.foldlevel = 99
    vim.opt.foldlevelstart = 99
    vim.opt.foldenable = true

    local ok, ufo = pcall(require, 'ufo')
    if not ok then
      return
    end

    ufo.setup {
      provider_selector = function()
        return { 'treesitter', 'indent' }
      end,
    }
  end,
}
