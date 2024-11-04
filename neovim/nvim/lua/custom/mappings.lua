local M = {}

M.dap = {
  plugin = true,
  n = {
    ["<leader>db"] = {
      function()
        require('dap').toggle_breakpoint()
      end}
  }
}

M.dap_python = {
  plugin = true,
  n = {
    ["<leader>dpl"] = {
      function()
        require('dap-python').test_method()
      end
    },
    ["<leader>db"] = {
      function()
        require('dap').toggle_breakpoint()
      end}
  }
}

return M
