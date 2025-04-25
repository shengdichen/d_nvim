local function set_paths()
    local base = "$HOME/.config/nvim/conf/"
    local conf_paths = table.concat(
        { base .. "/rpre/", "$VIMRUNTIME", base .. "/rpost/" }, ","
    )

    vim.o.runtimepath = conf_paths
    vim.o.packpath = conf_paths
end

local function main()
    set_paths()
end
main()
