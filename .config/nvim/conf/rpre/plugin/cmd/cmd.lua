local function terminal()
    -- prepend "+" to prevent editing a file named "terminal"
    vim.keymap.set("c", ":T", "split +terminal")

    local gid = vim.api.nvim_create_augroup(
        "TerminalMode",
        {clear = true}
    )
    vim.api.nvim_create_autocmd(
        {"TermOpen"},
        {pattern = {"*"}, group = gid, command = "startinsert"}
    )

    vim.keymap.set("t", "<C-C>", "<C-\\><C-n>")  -- exit terminal-mode
end

local function commandline()
    vim.opt.wildmenu = true  -- enable completion
    vim.optwildmode = "list:longest"  -- complete as much as possible

    vim.keymap.set("c", ":W", "wa!<Enter>")
    vim.keymap.set("c", "JJ", "<C-U><BS>")
end

local function search()
    vim.opt.hlsearch = true
    vim.opt.incsearch = ture

    vim.opt.ignorecase = true
    vim.opt.smartcase = true
end

local function main()
    terminal()
    commandline()
    search()
end
main()
