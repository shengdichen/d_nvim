local function enable()
    local use = 1
    vim.g.loaded_python3_provider = use
end

local function disable()
    local use = 0
    vim.g.loaded_node_provider = use
    vim.g.loaded_ruby_provider = use
    vim.g.loaded_perl_provider = use
end

local function main()
    enable()
    disable()
end
main()
