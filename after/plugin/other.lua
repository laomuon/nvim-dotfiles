require("Comment").setup()
require('ibl').setup({scope = {enabled = false}})
vim.keymap.set("n", "<leader><F5>", vim.cmd.UndotreeToggle)
