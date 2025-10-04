local function format_on_save(bufnr)
  local filetype = vim.bo[bufnr].filetype
  local disable_filetypes = { c = true, cpp = true }
  if disable_filetypes[filetype] then
    return nil
  end

  local timeout = 500
  if filetype == 'go' then
    timeout = 2000
  end

  return {
    timeout_ms = timeout,
    lsp_format = 'fallback',
  }
end

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = format_on_save,
    formatters_by_ft = {},
  },
}
