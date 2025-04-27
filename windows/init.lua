local function set_paths()
    local base = os.getenv("LOCALAPPDATA") .. "/nvim"
    local paths = table.concat(
        {
            base .. "/rpre",
            "$VIMRUNTIME",
            base .. "/rpost"
        },
        ","
    )

    vim.o.runtimepath = paths
    vim.o.packpath = paths
end

local function main()
    set_paths()
end
main()
