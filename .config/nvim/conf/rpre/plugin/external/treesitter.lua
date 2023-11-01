local c = require("nvim-treesitter.configs")

local function install()
    local conf = {
        ensure_installed = {
            "python", "lua", "haskell", "java", "c", "cpp",
            "vimdoc", -- builtin help-pages
            "typescript", "bash", "ruby",
        },
    }
    c.setup(conf)
end

local function setup()
    local conf = {
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false, -- use treesitter only
        },
    }
    c.setup(conf)
end

local function main()
    install()
    setup()
end
main()
