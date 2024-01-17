local function install(conf)
    -- REF:
    --  https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
    conf["ensure_installed"] = "all"
end

local function highlight(conf)
    conf["highlight"] = {
        enable = true,
        additional_vim_regex_highlighting = false, -- use treesitter only
    }
end

local function main()
    local conf = {}
    install(conf)
    highlight(conf)

    require("nvim-treesitter.configs").setup(conf)
end
main()
