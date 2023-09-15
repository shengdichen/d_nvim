local function visual()
    require("internal")["statusline"](2)
end

local function get_current_commit()
    vim.cmd("normal 0W") -- move to second column, where commit-hash starts

    -- |:help expand()|
    return vim.fn.expand("<cword>")
end

local function split_and_show(commit)
    vim.cmd("wincmd l | split")
    require("internal")["run_in_terminal"](
        require("git")["show"](commit)
    )
    vim.cmd("stopinsert") -- counter auto-insert in terminal-mode

    vim.cmd("wincmd h")
end

local function start_inspection()
    local pos = vim.api.nvim_win_get_cursor(0)

    split_and_show(get_current_commit())

    vim.api.nvim_win_set_cursor(0, pos)
end

local function stop_inspection()
    local n_splits_active = vim.fn.tabpagewinnr(vim.fn.tabpagenr(), "$")
    if n_splits_active > 2 then
        vim.cmd("wincmd l")
        vim.cmd("quit")
        vim.cmd("wincmd h")
    end
end

local function bind()
    vim.keymap.set("c", "wq", "w <bar> qa", { buffer = 0 })

    vim.keymap.set("n", "<Enter>", start_inspection, { buffer = 0 })
    vim.keymap.set("n", "Q", stop_inspection, { buffer = 0 })
end

local function autocmd()
    local g                      = require("git")
    local augroup, layout_double = g["augroup"], g["layout_double"]

    vim.api.nvim_create_autocmd(
        { "VimEnter" },
        {
            group = augroup,
            pattern = { "git-rebase-todo" },
            callback = layout_double(false)
        }
    )
end

local function main()
    visual()
    bind()
    autocmd()
end
main()
