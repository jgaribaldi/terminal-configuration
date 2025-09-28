local data_root = vim.fn.stdpath('data')
local data_writable = vim.fn.isdirectory(data_root) == 1 and vim.loop.fs_access(data_root, 'W')

return {
  'nvim-treesitter/nvim-treesitter',
  build = data_writable and ':TSUpdate' or nil,
  main = 'nvim-treesitter.configs',
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
      'rust',
    } or {},
    auto_install = data_writable,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { 'ruby' },
    },
    indent = { enable = true, disable = { 'ruby' } },
  },
  dependencies = {},
}
