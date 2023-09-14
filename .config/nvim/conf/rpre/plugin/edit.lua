local function filetype()
    -- :h :filetype-overview
    vim.cmd("filetype plugin indent on")
    -- :h :syn-qstart
    vim.cmd("syntax on")
end

local function format()
    vim.opt.backspace = { "indent", "eol", "start" }

    vim.opt.textwidth = 79

    vim.opt.autoindent = true

    vim.opt.expandtab = true -- spaces instead of tabs
    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
    vim.opt.shiftwidth = 4

    vim.opt.smarttab = true
    vim.opt.shiftround = true
end

local function trim_spaces()
    local function trim(trailing)
        local function f()
            local pos = vim.api.nvim_win_get_cursor(0)
            if trailing then
                vim.cmd([[%s/\s\+$//e]])
            else
                vim.cmd([[%s/^\s\+//e]])
            end
            vim.api.nvim_win_set_cursor(0, pos)
        end
        return f
    end

    local function remove_leading()
        local pos = vim.api.nvim_win_get_cursor(0)
        vim.api.nvim_win_set_cursor(0, pos)
    end

    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
        pattern = { "*" },
        callback = trim(true),
    })
end

local function cmd()
    vim.opt.mouse = "" -- disable mouse completely

    vim.opt.undolevels = 1000

    vim.opt.clipboard:append("unnamedplus") -- use system clipboard

    -- allow buffering even if unwritten modifications exist
    vim.opt.hidden = true
end

local function main()
    filetype()
    format()
    trim_spaces()
    cmd()
end
main()
