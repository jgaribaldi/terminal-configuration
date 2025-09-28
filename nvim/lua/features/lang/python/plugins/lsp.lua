return {
  'neovim/nvim-lspconfig',
  opts = function(_, opts)
    opts.servers = opts.servers or {}
    opts.servers.pyright = opts.servers.pyright or {}

    opts.ensure_installed = opts.ensure_installed or {}
    table.insert(opts.ensure_installed, 'pyright')
  end,
}
