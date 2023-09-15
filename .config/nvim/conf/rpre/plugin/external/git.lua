local run_in_terminal = require("cmd")["run_in_terminal"]

local show_log = require("git")["show_log"]
local show_cache_smart = require("git")["show_cache_smart"]

local function layout_triple()
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

local function layout_double(start_insert)
    return function()
        -- right
        vim.cmd("rightbelow vsplit")
        run_in_terminal(show_log())

        -- left
        vim.cmd("wincmd h")
        if start_insert then
            vim.cmd("startinsert")
        end
    end
end

local function create()
    local gid = vim.api.nvim_create_augroup(
        "GitLayout", { clear = true }
    )

    vim.api.nvim_create_autocmd(
        { "VimEnter" },
        {
            group = gid,
            pattern = { "COMMIT_EDITMSG" },
            callback = layout_triple
        }
    )
    vim.api.nvim_create_autocmd(
        { "VimEnter" },
        {
            group = gid,
            pattern = { "TAG_EDITMSG" },
            callback = layout_double(true)
        }
    )
    vim.api.nvim_create_autocmd(
        { "VimEnter" },
        {
            group = gid,
            pattern = { "MERGE_MSG", "git-rebase-todo" },
            callback = layout_double(false)
        }
    )
end

local function main()
    create()
end
main()
