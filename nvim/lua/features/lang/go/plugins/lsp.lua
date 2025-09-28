return {
  'neovim/nvim-lspconfig',
  opts = function(_, opts)
    opts.servers = opts.servers or {}
    opts.servers.gopls = opts.servers.gopls or {}

    opts.ensure_installed = opts.ensure_installed or {}
    table.insert(opts.ensure_installed, 'gopls')
  end,
}
