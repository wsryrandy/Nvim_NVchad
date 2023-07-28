local plugins =
{
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    init = function()
      require("core.utils").lazy_load "nvim-treesitter"
    end,
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = function()
      return require "plugins.configs.treesitter"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "syntax")
      require("nvim-treesitter.install").prefer_git = true
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opt = {
      handlers = {}
    },
  },
  {
    "mfussenegger/nvim-dap", -- debugger environment for nvim
    init = function()
      require("core.utils").load_mappings("dap")
    end,
  },
  {
    "leoluz/nvim-dap-go", -- golang plugin for dap
    ft = "go",
    dependencies = {
         "mfussenegger/nvim-dap",
         "rcarriga/nvim-dap-ui",
     },
    config = function (_, opts)
      require("dap-go").setup(opts)
      require("core.utils").load_mappings("dap_go")
    end
  },

  {
     "rcarriga/nvim-dap-ui",
     dependencies = "mfussenegger/nvim-dap",
     config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end
  },
  {
     "mfussenegger/nvim-dap-python",
     ft = "python",
     dependencies = {
         "mfussenegger/nvim-dap",
         "rcarriga/nvim-dap-ui",
     },
     config = function(_, opts)
      local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bbin/python"
      require("dap-python").setup(path)
      require("core.utils").load_mappings("dap_python") 
     end,
  },


  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end
  },
  {
    -- null-ls plugin for formatting
    "jose-elias-alvarez/null-ls.nvim",
    ft = {"go", "python"},
    opts = function()
      return require "custom.configs.null-ls"
    end,
  },
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    config = function(_, opts)
      require("gopher").setup(opts)
      require("core.utils").load_mappings("gopher")
    end,
    build = function ()
      vim.cmd [[silent! GoInstallDeps]]
    end
  },
  {
    -- use :MasonInstallAll command to install, or manually install
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "clangd",
        "clang-format",
        "codelldb",
--        "rust-analyzer",
        "gopls",
        "golines",
        "gofumpt",
        "goimports-reviser",
        "delve", -- golang debugger
        "pyright",
        "mypy",
        "ruff",
        "black",
        "debugpy",
        "lua-language-server",
      },
    },
  }
}

return plugins
