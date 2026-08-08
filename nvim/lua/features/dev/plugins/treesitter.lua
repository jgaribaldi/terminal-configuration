local data_root = vim.fn.stdpath 'data'
local data_writable = vim.fn.isdirectory(data_root) == 1 and vim.loop.fs_access(data_root, 'W')

return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  build = data_writable and ':TSUpdate' or nil,
  main = 'nvim-treesitter',
  opts = {
    ensure_installed = data_writable and {
      'bash',
      'c',
      'diff',
      'html',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'query',
      'vim',
      'vimdoc',
      'python',
      'go',
      'rust',
    } or {},
    auto_install = data_writable,
  },
  init = function()
    vim.api.nvim_create_autocmd('FileType', {
      callback = function()
        pcall(vim.treesitter.start)
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
  dependencies = {},
}
