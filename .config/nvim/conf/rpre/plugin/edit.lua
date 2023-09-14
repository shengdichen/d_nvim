local function format()
    vim.opt.backspace = { "indent", "eol", "start" }

    vim.opt.textwidth = 79

    vim.opt.autoindent = true

    vim.opt.expandtab = true -- spaces instead of tabs
    vim.opt.smarttab = true
    vim.opt.shiftround = true

    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
    vim.opt.shiftwidth = 4
end

local function remove_redundant_spaces()
    local function remove_trailing()
        pos = vim.api.nvim_win_get_cursor(0)
        vim.cmd([[%s/\s\+$//e]])
        vim.api.nvim_win_set_cursor(0, pos)
    end

    local function remove_leading()
        pos = vim.api.nvim_win_get_cursor(0)
        vim.cmd([[%s/^\s\+//e]])
        vim.api.nvim_win_set_cursor(0, pos)
    end

    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
        pattern = { "*" },
        callback = remove_trailing,
    })
end

local function cmd()
    vim.opt.undolevels = 1000

    vim.opt.clipboard:append("unnamedplus") -- use system clipboard

    -- allow buffering even if unwritten modifications exist
    vim.opt.hidden = true
end

local function main()
    format()
    remove_redundant_spaces()
    cmd()
end
main()
