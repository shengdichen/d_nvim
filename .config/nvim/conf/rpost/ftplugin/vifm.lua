local function unbind_help()
    -- conflicts with |K| (for navigation)
    vim.api.nvim_del_augroup_by_name("VifmHelpAutoCmds")
end

local function main()
    unbind_help()
end
main()
