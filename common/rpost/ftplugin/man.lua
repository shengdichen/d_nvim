local function visual()
    -- set to nil to use global value
    vim.opt_local.number = nil
    vim.opt_local.relativenumber = nil
end

local function main()
    visual()
end
main()
