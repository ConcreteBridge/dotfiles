local add_keymap = require("which-key").add

add_keymap {
  mode = "v",
  "gs",
  "!sort<cr>",
  desc = "Sort selection",
  icon = "",
}
