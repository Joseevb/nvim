vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Oil)
vim.keymap.set("n", "<C-c>", vim.cmd.Esc)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("n", "<leader>ft", ":NvimTreeToggle <CR>")

vim.keymap.set("n", "<leader>je", ":split | term java -cp .\\bin\\ App <CR>")
vim.keymap.set("n", "<leader>jc", ":split | term javac -d .\\bin\\ .\\src\\*.java <CR>")

vim.keymap.set("n", "<leader>mj", ":! mkdir .\\bin\\ && mkdir .\\src\\ && type nul > .\\src\\App.java <CR><CR>")

--requires live server to be installed npm i -g live-server
vim.keymap.set("n", "<leader>ls", ":term live-server . <CR>")
