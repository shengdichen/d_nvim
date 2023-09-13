local function visual()
    vim.opt_local.laststatus = 2 -- show full status-line

    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en"
end

local function bind()
    vim.keymap.set("c", "wq", "w <bar> qa", { buffer = 0 })
end

local function run_in_terminal(cmd)
    vim.cmd("terminal $SHELL -c " .. '"' .. cmd .. '"')
end

local function show_log()
    return "git log --all --patch --graph"
end

local function show_cache()
    return "if git diff --cached --quiet; then git show @; else git diff --cached; fi"
end

local function layout()
    local gid = vim.api.nvim_create_augroup(
        "GitComposeLayout", { clear = true }
    )

    local function triple()
        vim.cmd("rightbelow vsplit")

        -- lower-right
        vim.cmd("rightbelow split")
        run_in_terminal(show_log())

        -- upper-right
        vim.cmd("wincmd k")
        run_in_terminal(show_cache())

        -- left
        vim.cmd("wincmd h")
        vim.cmd("startinsert")
    end

    local function double()
        -- right
        vim.cmd("rightbelow vsplit")
        run_in_terminal(show_log())

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
        { pattern = { "TAG_EDITMSG", "MERGE_MSG" }, group = gid, callback = double }
    )
end

local function main()
    visual()
    bind()
    layout()
end
main()
