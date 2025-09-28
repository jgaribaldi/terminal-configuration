return {
  'neovim/nvim-lspconfig',
  opts = function(_, opts)
    opts.servers = opts.servers or {}
    local server = opts.servers.lua_ls or {}
    server.settings = server.settings or {}
    server.settings.Lua = vim.tbl_deep_extend('force', {
      completion = {
        callSnippet = 'Replace',
      },
    }, server.settings.Lua or {})
    opts.servers.lua_ls = server

    opts.ensure_installed = opts.ensure_installed or {}
    table.insert(opts.ensure_installed, 'stylua')
  end,
}
