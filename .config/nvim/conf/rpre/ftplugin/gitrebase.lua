local function visual()
    vim.opt_local.laststatus = 2
end

local function get_current_commit()
    vim.cmd("normal 0W") -- move to second column, where commit-hash starts

    -- |:help expand()|
    return vim.fn.expand("<cword>")
end

local function split_and_show(commit)
    vim.cmd("wincmd l | split")
    vim.cmd(
        "terminal $SHELL -c " ..
        '"' ..
        "git show " .. commit ..
        '"'
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

local function main()
    visual()
    bind()
end
main()
