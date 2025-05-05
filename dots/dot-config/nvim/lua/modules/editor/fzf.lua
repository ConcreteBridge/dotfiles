require("pckr").add {
  {
    "ibhagwan/fzf-lua",
    config = function()
      require("fzf-lua").setup {
        "borderless",
        fzf_colors = true,
      }

      require("which-key").add {
        mode = "n",
        {
          "<leader>b",
          "<cmd>FzfLua buffers<cr>",
          desc = "Buffers",
          icon = { icon = "", color = "cyan" },
        },
        {
          "<leader>f",
          "<cmd>FzfLua files<cr>",
          desc = "Files",
          icon = { icon = "󰈔", color = "cyan" },
        },
        {
          "<leader>g",
          "<cmd>FzfLua live_grep_native<cr>",
          desc = "Grep",
          icon = { icon = "󰥨", color = "cyan" },
        },
        {
          "<leader>l",
          "<cmd>FzfLua lines<cr>",
          desc = "Lines",
          icon = { icon = "󰱼", color = "cyan" },
        },
        {
          "<leader>r",
          "<cmd>FzfLua oldfiles<cr>",
          desc = "Recent",
          icon = { icon = "󱋡", color = "cyan" },
        },
        {
          "<leader>z",
          "<cmd>FzfLua zoxide<cr>",
          desc = "Zoxide",
          icon = { icon = "󰉋", color = "cyan" },
        },
        { "<leader>n", group = "Neovim" },
        {
          "<leader>nf",
          "<cmd>FzfLua files cwd=~/.config/nvim<cr>",
          desc = "Config Files",
        },
        {
          "<leader>ng",
          "<cmd>FzfLua live_grep_native cwd=~/.config/nvim<cr>",
          desc = "Grep Config",
          icon = { icon = "󰥨", color = "cyan" },
        },
      }
    end,
  },
}
