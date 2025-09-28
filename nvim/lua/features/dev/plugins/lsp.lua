local function setup_diagnostics()
  vim.diagnostic.config {
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = vim.diagnostic.severity.ERROR },
    signs = vim.g.have_nerd_font and {
      text = {
        [vim.diagnostic.severity.ERROR] = '󰅚 ',
        [vim.diagnostic.severity.WARN] = '󰀪 ',
        [vim.diagnostic.severity.INFO] = '󰋽 ',
        [vim.diagnostic.severity.HINT] = '󰌶 ',
      },
    } or {},
    virtual_text = {
      source = 'if_many',
      spacing = 2,
      format = function(diagnostic)
        local message = {
          [vim.diagnostic.severity.ERROR] = diagnostic.message,
          [vim.diagnostic.severity.WARN] = diagnostic.message,
          [vim.diagnostic.severity.INFO] = diagnostic.message,
          [vim.diagnostic.severity.HINT] = diagnostic.message,
        }
        return message[diagnostic.severity]
      end,
    },
  }
end

local function setup_lsp_keymaps(event)
  local function map(keys, func, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
  end

  map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
  map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
  map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
  map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
  map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

  local function client_supports_method(client, method, bufnr)
    if vim.fn.has 'nvim-0.11' == 1 then
      return client:supports_method(method, bufnr)
    else
      return client.supports_method(method, { bufnr = bufnr })
    end
  end

  local client = vim.lsp.get_client_by_id(event.data.client_id)
  if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
    local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      buffer = event.buf,
      group = highlight_augroup,
      callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      buffer = event.buf,
      group = highlight_augroup,
      callback = vim.lsp.buf.clear_references,
    })

    vim.api.nvim_create_autocmd('LspDetach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
      callback = function(event2)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
      end,
    })
  end

  if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
    map('<leader>th', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
    end, '[T]oggle Inlay [H]ints')
  end
end

local function on_lsp_attach()
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = setup_lsp_keymaps,
  })
end

local function setup_servers(opts)
  local servers = opts.servers or {}
  local capabilities = opts.capabilities or require('blink.cmp').get_lsp_capabilities()

  local data_root = vim.fn.stdpath('data')
  if vim.fn.isdirectory(data_root) == 0 or not vim.loop.fs_access(data_root, 'W') then
    return
  end

  local ok_mason, mason = pcall(require, 'mason')
  if not ok_mason then
    return
  end

  local ok_setup = pcall(mason.setup, opts.mason or {})
  if not ok_setup then
    return
  end

  local ensure_installed = vim.tbl_keys(servers)
  vim.list_extend(ensure_installed, opts.ensure_installed or {})

  local unique = {}
  local seen = {}
  for _, item in ipairs(ensure_installed) do
    if not seen[item] then
      table.insert(unique, item)
      seen[item] = true
    end
  end

  local ok_mti, mason_tool_installer = pcall(require, 'mason-tool-installer')
  if ok_mti then
    pcall(mason_tool_installer.setup, { ensure_installed = unique })
  end

  local ok_mlsp, mason_lspconfig = pcall(require, 'mason-lspconfig')
  if not ok_mlsp then
    return
  end

  mason_lspconfig.setup {
    handlers = {
      function(server_name)
        local server = servers[server_name] or {}
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        require('lspconfig')[server_name].setup(server)
      end,
    },
  }
end

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'mason-org/mason.nvim', opts = {} },
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    'saghen/blink.cmp',
  },
  opts = {
    servers = {},
    ensure_installed = {},
  },
  config = function(_, opts)
    on_lsp_attach()
    setup_diagnostics()
    setup_servers(opts)
  end,
}
