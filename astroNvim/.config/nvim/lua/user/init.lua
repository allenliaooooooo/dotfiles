return {
  colorscheme = "kanagawa",

  plugins = {
    {
      "rebelot/kanagawa.nvim",
      name = "kanagawa",
      config = function()
        require("kanagawa").setup {}
      end,
    },
    {
      "kylechui/nvim-surround",
      version = "*", -- Use for stability; omit to use `main` branch for the latest features
      event = "VeryLazy",
      config = function()
        require("nvim-surround").setup({
          -- Configuration here, or leave empty to use defaults
        })
      end,
    },

    -- Overriding the default astronvim setting
    {
      "nvim-neo-tree/neo-tree.nvim",
      opts = {
        filesystem = {
          filtered_items = {
            visible = true, -- show the dotfile in the file explorer
          },
        },
      },
    },
  },

  options = function(local_vim) -- parameter is the default table to be overridden
    -- nil is the same as a key not being set, so you cannot use nil reliably
    -- when using the table override notation
    -- local_vim.clipboard = nil -- set a value to nil to remove it from the table
    local_vim.opt.scrolloff = 999
    -- return modified table
    return local_vim
  end,
}
