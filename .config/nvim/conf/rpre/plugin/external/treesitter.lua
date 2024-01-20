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

local function fold()
    -- REF:
    --  https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#folding
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

    -- NOTE:
    --  1. just enough for one indent-level in a (class-)method
    --  2. use |vim.opt.foldenable = false| for full expansion
    vim.opt.foldlevel = 3
end

local function main()
    local conf = {}
    install(conf)
    highlight(conf)
    fold()

    require("nvim-treesitter.configs").setup(conf)
end
main()
