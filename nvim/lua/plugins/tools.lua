return {
  -- Toolchains are provided by Nix or project-specific devShells.
  { "mason-org/mason.nvim", enabled = false },
  { "mason-org/mason-lspconfig.nvim", enabled = false },
  { "jay-babu/mason-nvim-dap.nvim", enabled = false },

  -- Avoid requiring a compiler just to start Neovim in WSL.
  { "nvim-treesitter/nvim-treesitter", enabled = false },
  { "nvim-treesitter/nvim-treesitter-textobjects", enabled = false },
  { "windwp/nvim-ts-autotag", enabled = false },
  { "saghen/blink.cmp", opts = { fuzzy = { implementation = "lua" } } },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {},
        nixd = { cmd = { "nixd" } },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        go = { "gofumpt" },
        nix = { "nixfmt" },
      },
    },
  },
}
