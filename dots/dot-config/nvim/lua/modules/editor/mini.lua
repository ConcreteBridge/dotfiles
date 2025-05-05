require("pckr").add {
  {
    "echasnovski/mini.nvim",
    config = function()
      for lib, opt in pairs {
        ai = {},
        align = {},
        bracketed = {},
        bufremove = {},
        comment = {
          options = {
            custom_commentstring = function()
              return require("ts_context_commentstring").calculate_commentstring()
                or vim.bo.commentstring
            end,
          },
        },
        cursorword = {},
        diff = {},
        icons = {},
        map = {},
        move = {},
        operators = {},
        pairs = {},
        starter = {},
        statusline = {},
        surround = {},
        tabline = {},
      } do
        if #opt == 0 then
          require("mini." .. lib).setup()
        else
          require("mini." .. lib).setup(opt)
        end
      end

      require("which-key").add {
        mode = "n",
        "<leader>d",
        function() require("mini.starter").open() end,
        desc = "Dashboard",
        icon = { icon = "󰋜", color = "cyan" },
      }
    end,
  },
}
