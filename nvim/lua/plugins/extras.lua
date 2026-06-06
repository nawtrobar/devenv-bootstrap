return {
  -- Colorscheme: Catppuccin Mocha
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = { flavour = "mocha" },
  },
  { "LazyVim/LazyVim", opts = { colorscheme = "catppuccin" } },

  -- Better surround
  { "kylechui/nvim-surround", event = "VeryLazy", config = true },

  -- Harpoon for quick file navigation
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ha", function() require("harpoon"):list():add() end,     desc = "Harpoon add" },
      { "<leader>hh", function() local h = require("harpoon") require("harpoon.ui"):toggle_quick_menu(h:list()) end, desc = "Harpoon menu" },
      { "<leader>1",  function() require("harpoon"):list():select(1) end, desc = "Harpoon 1" },
      { "<leader>2",  function() require("harpoon"):list():select(2) end, desc = "Harpoon 2" },
      { "<leader>3",  function() require("harpoon"):list():select(3) end, desc = "Harpoon 3" },
      { "<leader>4",  function() require("harpoon"):list():select(4) end, desc = "Harpoon 4" },
    },
  },

  -- Undotree
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = { { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Undotree" } },
  },

  -- Better diagnostics display
  {
    "folke/trouble.nvim",
    opts = { use_diagnostic_signs = true },
  },

  -- Inline git blame
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = { delay = 500 },
    },
  },
}
