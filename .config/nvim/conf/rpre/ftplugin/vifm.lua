local util_vim = require("util_vim")

local function unbind_help()
    local gr = "VifmHelpAutoCmds"
    if util_vim.augroup.has_name(gr) then
        -- conflicts with |K| (for navigation)
        vim.api.nvim_del_augroup_by_name(gr)
    end
end

local function main()
    unbind_help()
end
main()
