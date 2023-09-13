local function run_in_terminal(cmd)
    vim.cmd("terminal $SHELL -c " .. '"' .. cmd .. '"')
end

local function show_log()
    return "git log --all --patch --graph"
end

local function show_cache_smart()
    -- show currently staged if existent, otherwise inspect HEAD
    cmd = "if " ..
        "git diff --cached --quiet" ..
        "; then " ..
        "git show @" ..
        "; else " ..
        "git diff --cached" ..
        "; fi"
    return cmd
end

local function commit(gid)
    local function triple()
        vim.cmd("rightbelow vsplit")

        -- lower-right
        vim.cmd("rightbelow split")
        run_in_terminal(show_log())

        -- upper-right
        vim.cmd("wincmd k")
        run_in_terminal(show_cache_smart())

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

local function rebase(gid)
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
    local gid = vim.api.nvim_create_augroup(
        "GitLayout", { clear = true }
    )

    commit(gid)
    rebase(gid)
end
main()
