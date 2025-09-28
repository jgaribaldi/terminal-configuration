local function setup_signs()
  vim.fn.sign_define('DapBreakpoint', {
    text = '●',
    texthl = 'DapBreakpoint',
    linehl = 'DapBreakpointLine',
    numhl = 'DapBreakpoint',
  })
  vim.fn.sign_define('DapBreakpointCondition', {
    text = '◐',
    texthl = 'DapBreakpointCondition',
    linehl = 'DapBreakpointLine',
    numhl = 'DapBreakpointCondition',
  })
  vim.fn.sign_define('DapStopped', {
    text = '▶',
    texthl = 'DapStopped',
    linehl = 'DapStopped',
    numhl = 'DapStopped',
  })
end

local function setup_keymaps()
  local function map(lhs, rhs, desc)
    vim.keymap.set('n', lhs, rhs, { desc = desc })
  end

  map('<leader>ds', function()
    require('dap').continue()
  end, 'Debug: Start/Continue')
  map('<leader>di', function()
    require('dap').step_into()
  end, 'Debug: Step Into')
  map('<leader>dv', function()
    require('dap').step_over()
  end, 'Debug: Step Over')
  map('<leader>do', function()
    require('dap').step_out()
  end, 'Debug: Step Out')
  map('<leader>db', function()
    require('dap').toggle_breakpoint()
  end, 'Debug: Toggle Breakpoint')
  map('<leader>dB', function()
    require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
  end, 'Debug: Set Breakpoint')
  map('<leader>dS', function()
    require('dap').close()
    require('dapui').close()
  end, 'Debug: Close debug session')
  map('<leader>dui', function()
    require('dapui').toggle()
  end, 'Debug: Toggle UI')
end

local function setup_mason(ensure)
  local unique = {}
  local seen = {}
  for _, item in ipairs(ensure or {}) do
    if not seen[item] then
      table.insert(unique, item)
      seen[item] = true
    end
  end

  local data_root = vim.fn.stdpath('data')
  if vim.fn.isdirectory(data_root) == 0 or not vim.loop.fs_access(data_root, 'W') then
    return
  end

  local ok, mason_dap = pcall(require, 'mason-nvim-dap')
  if not ok then
    return
  end

  pcall(mason_dap.setup, {
    automatic_installation = true,
    handlers = {},
    ensure_installed = unique,
  })
end

local function setup_dap_ui()
  local ok, dapui = pcall(require, 'dapui')
  if not ok then
    return
  end

  dapui.setup {
    icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
    controls = {
      icons = {
        pause = '⏸',
        play = '▶',
        step_into = '⏎',
        step_over = '⏭',
        step_out = '⏮',
        step_back = 'b',
        run_last = '▶▶',
        terminate = '⏹',
        disconnect = '⏏',
      },
    },
  }
end

local function setup_highlights()
  vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = '#f7768e', bold = true })
  vim.api.nvim_set_hl(0, 'DapBreakpointCondition', { fg = '#e0af68', bold = true })
  vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#9ece6a', bold = true })
  vim.api.nvim_set_hl(0, 'DapBreakpointLine', { bg = '#3d2a2a' })
end

local function setup_listeners()
  local ok_dap, dap = pcall(require, 'dap')
  if not ok_dap then
    return
  end

  local ok_ui, dapui = pcall(require, 'dapui')
  if not ok_ui then
    return
  end

  dap.listeners.after.event_initialized['dapui_config'] = dapui.open
  dap.listeners.before.event_terminated['dapui_config'] = dapui.close
  dap.listeners.before.event_exited['dapui_config'] = dapui.close
end

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
  },
  opts = {
    ensure_installed = {},
    setup = {},
  },
  config = function(_, opts)
    setup_keymaps()
    setup_mason(opts.ensure_installed)
    setup_dap_ui()
    setup_listeners()
    setup_highlights()
    setup_signs()

    for _, configure in ipairs(opts.setup or {}) do
      pcall(configure)
    end
  end,
}
