local function visual()
    vim.opt_local.laststatus = 2
end

local function bind()
    vim.keymap.set("c", "wq", "w <bar> qa", { buffer = 0 })
end

local function layout()
    local gid = vim.api.nvim_create_augroup(
        "GitRebaseLayout",
        { clear = true }
    )

    local function double()
        -- right
        vim.cmd("rightbelow vsplit")
        vim.cmd([[terminal $SHELL -c "git log --all --patch --graph"]])

        -- left
        vim.cmd("wincmd h")
    end

    vim.api.nvim_create_autocmd(
        { "VimEnter" },
        { pattern = { "git-rebase-todo" }, group = gid, callback = double }
    )
end

local function main()
    visual()
    bind()
    layout()
end
main()
