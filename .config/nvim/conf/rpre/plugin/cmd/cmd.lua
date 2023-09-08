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

local function main()
    terminal()
end
main()
