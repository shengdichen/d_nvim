local function assemble()
    local conf = ""

    local function left()
        conf = conf .. "%.37F"

        conf = conf .. "  "

        conf = conf ..
            "%{" ..
            '&filetype!=""' ..
            "?" ..
            '">".&filetype' .. -- recognized
            ":" ..
            '"?type"' ..       -- non-type
            "}"
        conf = conf ..
            "%{" ..
            "&readonly==0" ..
            "?" ..
            "&modifiable!=0" ..
            "?" ..
            '""' ..    -- RO & modifiable
            ":" ..
            '"|!W"' .. -- not-RO & not-modifiable
            ":" ..
            "&modifiable!=0" ..
            "?" ..
            '"|RO"' ..   -- RO & modifiable
            ":" ..
            '"|RO!W"' .. -- RO & not-modifiable
            "}"
    end

    local function separator()
        conf = conf .. "%="
    end

    local function right()
        conf = conf ..
            "%{" ..
            '&modified==""' ..
            "?" ..
            '""' ..            -- not-modified
            ":" ..
            '"!Pending!  "' .. -- modified
            "}"
        conf = conf .. "(%02c, %03l/%03L)"
    end

    left()
    separator()
    right()
    vim.opt.statusline = conf
end

local function hide()
    vim.opt.laststatus = 0
    vim.cmd("redraw")
end

local function show_if_modified()
    if vim.api.nvim_buf_get_option(0, "modified") then
        vim.opt.laststatus = 2
    else
        vim.opt.laststatus = 0
    end
end

local function show(redraw)
    local function f()
        vim.opt.laststatus = 2
        if redraw then
            vim.cmd("redrawstatus")
        end
    end

    return f
end

local function make_autocmds()
    local gid = vim.api.nvim_create_augroup(
        "StatuslineToggle", { clear = true }
    )

    vim.api.nvim_create_autocmd(
        { "FileWritePost", "BufWritePost", "CmdlineLeave" },
        { pattern = { "*" }, group = gid, callback = hide }
    )
    vim.api.nvim_create_autocmd(
        { "InsertLeave", "CmdLineLeave", "TextChanged", "TextChangedI", "TextChangedP" },
        { pattern = { "*" }, group = gid, callback = show_if_modified }
    )
    vim.api.nvim_create_autocmd(
        { "InsertEnter" },
        { pattern = { "*" }, group = gid, callback = show(false) }
    )
    vim.api.nvim_create_autocmd(
        { "CmdlineEnter" },
        { pattern = { "*" }, group = gid, callback = show(true) }
    )
end

local function general()
    vim.opt.laststatus = 0 -- hide by default

    vim.opt.ruler = false  -- use our own cursor-coordinate display instead

    -- display incomplete commands in operator-pending mode
    vim.opt.showcmd = true

    vim.opt.showmode = false
end

local function main()
    assemble()
    make_autocmds()
    general()
end
main()
