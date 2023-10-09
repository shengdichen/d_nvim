local c = require("nvim-treesitter.configs")

local function install()
    local conf = {
        ensure_installed = {
            "python", "lua", "java", "c", "cpp",
            "vimdoc", -- builtin help-pages
            "typescript", "bash", "ruby",
        },
    }
    c.setup(conf)
end

local function setup()
    local conf = {
        highlight = { enable = true },
    }
    c.setup(conf)
end

local function main()
    install()
    setup()
end
main()
