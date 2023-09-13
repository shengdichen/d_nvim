-- NOTE:
--  1. find name for keys from |:h key-notation|

local function general()
    vim.keymap.set("i", "jj", "<ESC>")

    vim.opt.backspace = { "indent", "eol", "start" }

    vim.keymap.set("n", "<S-CR>", 'o<Esc>0"_D') -- |"_| := blackhole-buffer
end

local function main()
    general()
end
main()
