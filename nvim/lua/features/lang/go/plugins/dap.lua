return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'leoluz/nvim-dap-go',
  },
  opts = function(_, opts)
    opts.ensure_installed = opts.ensure_installed or {}
    table.insert(opts.ensure_installed, 'delve')

    opts.setup = opts.setup or {}
    table.insert(opts.setup, function()
      local ok, dapgo = pcall(require, 'dap-go')
      if not ok then
        return
      end
      dapgo.setup {
        delve = {
          detached = vim.fn.has 'win32' == 0,
        },
      }
    end)
  end,
}
