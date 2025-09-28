return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'mfussenegger/nvim-dap-python',
  },
  opts = function(_, opts)
    opts.ensure_installed = opts.ensure_installed or {}
    table.insert(opts.ensure_installed, 'debugpy')

    opts.setup = opts.setup or {}
    table.insert(opts.setup, function()
      local ok, dappy = pcall(require, 'dap-python')
      if not ok then
        return
      end
      dappy.setup '~/.local/pipx/venvs/debugpy/bin/python'
    end)
  end,
}
