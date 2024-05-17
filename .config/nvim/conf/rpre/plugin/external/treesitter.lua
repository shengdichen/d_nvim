local c = {}

local function install()
    -- REF:
    --  https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
    c["ensure_installed"] = "all"
end

local function highlight()
    c["highlight"] = {
        enable = true,
        additional_vim_regex_highlighting = false, -- use treesitter only
    }
end

local function fold()
    -- REF:
    --  https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#folding
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

    -- just enough for one indent-level in a (class-)method
    vim.opt.foldlevel = 3

    -- do NOT auto-fold
    vim.opt.foldenable = false
end

local function main()
    install()
    highlight()
    require("nvim-treesitter.configs").setup(c)

    fold()
end
main()
