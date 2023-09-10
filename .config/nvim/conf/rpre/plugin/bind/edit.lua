-- NOTE:
--  1. find name for keys from |:h key-notation|

local function general()
    vim.keymap.set("i", "jj", "<ESC>")

    vim.opt.backspace = { "indent", "eol", "start" }

    vim.keymap.set("n", "<S-CR>", 'o<Esc>0"_D') -- |"_| := blackhole-buffer
end

local function navigation()
    vim.keymap.set("i", "<PageUp>", "")
    vim.keymap.set("i", "<PageDown>", "")

    vim.keymap.set("i", "<C-h>", "<Left>")
    vim.keymap.set("i", "<C-j>", "<Down>")
    vim.keymap.set("i", "<C-k>", "<Up>")
    vim.keymap.set("i", "<C-l>", "<Right>")

    vim.keymap.set("i", "<C-b>", "<C-Left>")
    vim.keymap.set("i", "<C-w>", "<C-Right>")

    vim.keymap.set("i", "<C-e>", "<ScrollWheelDown>")
    vim.keymap.set("i", "<C-y>", "<ScrollWheelUp>")
end

local function main()
    general()
    navigation()
end
main()
