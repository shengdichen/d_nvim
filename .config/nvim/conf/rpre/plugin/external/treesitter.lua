local c = require("nvim-treesitter.configs")

local function install()
    -- REF:
    --  https://github.com/nvim-treesitter/nvim-treesitter#supported-languages

    local conf = {
        -- ensure_installed = {
        --     "python", "lua",
        --     "typescript", "javascript",
        --     "haskell", "java", "c", "cpp",
        --     "vimdoc", -- builtin help-pages
        --     "bash", "ruby",
        -- },
        ensure_installed = "all"
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
