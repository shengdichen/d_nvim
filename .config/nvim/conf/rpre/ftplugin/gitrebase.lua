local function visual()
    vim.opt_local.laststatus = 2
end

local function get_current_word()
    -- |:help expand()|
    return vim.fn.expand("<cword>")
end

local function inspect_commit()
    cmd = "git show " .. get_current_word()

    vim.cmd("wincmd l | split")
    vim.cmd("terminal $SHELL -c " .. '"' .. cmd .. '"')

    vim.cmd("wincmd h")
    vim.cmd("stopinsert")
end

local function bind()
    vim.keymap.set("c", "wq", "w <bar> qa", { buffer = 0 })

    vim.keymap.set("n", "<Enter>", inspect_commit, { buffer = 0 })
end

local function main()
    visual()
    bind()
end
main()
