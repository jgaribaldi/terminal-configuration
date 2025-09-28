return {
  'ray-x/go.nvim',
  dependencies = {
    'ray-x/guihua.lua',
    'neovim/nvim-lspconfig',
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {},
  config = function(_, opts)
    local ok, go = pcall(require, 'go')
    if not ok then
      return
    end

    go.setup(opts)
    local format_sync_grp = vim.api.nvim_create_augroup('GoFormat', {})
    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = '*.go',
      callback = function()
        local ok_fmt, gofmt = pcall(require, 'go.format')
        if ok_fmt then
          gofmt.goimports()
        end
      end,
      group = format_sync_grp,
    })
  end,
  event = { 'CmdlineEnter' },
  ft = { 'go', 'gomod' },
  build = ':lua require("go.install").update_all_sync()',
}
