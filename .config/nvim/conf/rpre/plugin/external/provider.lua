local function configure()
    local enable = 1
    local disable = 0

    vim.g.loaded_python3_provider = enable

    vim.g.loaded_node_provider = disable
    vim.g.loaded_ruby_provider = disable
    vim.g.loaded_perl_provider = disable
end

local function main()
    configure()
end
main()
