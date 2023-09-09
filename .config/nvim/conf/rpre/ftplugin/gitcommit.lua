local function visual()
    vim.opt_local.laststatus = 2 -- show full status-line

    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en"
end

local function bind()
    vim.keymap.set("c", "wq", "w <bar> qa", { buffer = 0 })
end

local function layout()
    local gid = vim.api.nvim_create_augroup(
        "GitComposeLayout",
        { clear = true }
    )

    local function triple()
        vim.cmd("rightbelow vsplit")

        -- lower-right
        vim.cmd("rightbelow split")
        vim.cmd([[terminal $SHELL -c "git log --all --oneline --graph"]])

        -- upper-right
        vim.cmd("wincmd k")
        vim.cmd([[terminal $SHELL -c "git diff --cached --unified=1"]])

        -- left
        vim.cmd("wincmd h")
        vim.cmd("startinsert")
    end

    local function double()
        -- right
        vim.cmd("rightbelow vsplit")
        vim.cmd([[terminal $SHELL -c "git log --all --patch --graph"]])

        -- left
        vim.cmd("wincmd h")
        vim.cmd("startinsert")
    end

    vim.api.nvim_create_autocmd(
        { "VimEnter" },
        { pattern = { "COMMIT_EDITMSG" }, group = gid, callback = triple }
    )

    vim.api.nvim_create_autocmd(
        { "VimEnter" },
        { pattern = { "TAG_EDITMSG", "MERGE_EDITMSG" }, group = gid, callback = double }
    )
end

local function main()
    visual()
    bind()
    layout()
end
main()
