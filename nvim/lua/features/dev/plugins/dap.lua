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

local function setup_mason()
  require('mason-nvim-dap').setup {
    automatic_installation = true,
    handlers = {},
    ensure_installed = {
      'delve',
      'debugpy',
    },
  }
end

local function setup_dap_ui()
  require('dapui').setup {
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
  local dap = require 'dap'
  local dapui = require 'dapui'

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
    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python',
  },
  config = function()
    setup_keymaps()
    setup_mason()
    setup_dap_ui()
    setup_listeners()

    require('dap-go').setup {
      delve = {
        detached = vim.fn.has 'win32' == 0,
      },
    }

    require('dap-python').setup '~/.local/pipx/venvs/debugpy/bin/python'
    setup_highlights()
    setup_signs()
  end,
}
