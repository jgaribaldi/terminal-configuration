local function register_autocmd()
  local lint = require 'lint'
  local group = vim.api.nvim_create_augroup('lint', { clear = true })
  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
    group = group,
    callback = function()
      if vim.bo.modifiable then
        lint.try_lint()
      end
    end,
  })
end

return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require 'lint'
    lint.linters_by_ft = {
      markdown = { 'markdownlint-cli2' },
    }
    register_autocmd()
  end,
}
