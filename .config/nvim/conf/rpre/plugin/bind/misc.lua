local function leader()
    vim.g.mapleader = " " -- |space| as leader-key
end

local function edit()
    vim.keymap.set("i", "jj", "<ESC>")

    vim.keymap.set("n", "<S-CR>", 'o<Esc>0"_D') -- |"_| := blackhole-buffer
end

local function main()
    leader()
    edit()
end
main()
