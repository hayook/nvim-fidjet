local fidjet = require("fidjet")

-- open tab view
vim.keymap.set("n", "<leader>tt", fidjet.displayOpenFiles)

vim.keymap.set("n", "<leader>tw", fidjet.closeCurren:File)

-- Navigation between files
vim.keymap.set("n", "<leader>th", ":bp<CR>")
vim.keymap.set("n", "<leader>tl", ":bn<CR>")
vim.keymap.set("n", "<leader>ts", ":w<CR>")
vim.keymap.set("n", "<leader>tq", ":q<CR>")
