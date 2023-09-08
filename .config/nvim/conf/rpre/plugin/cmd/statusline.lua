local function statusline()
    vim.opt.ruler = false  -- use our own cursor-coordinate display instead

    -- display incomplete commands in operator-pending mode
    vim.opt.showcmd = true

    vim.opt.showmode = false
end

local function main()
    statusline()
end
main()
