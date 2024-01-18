local function infinite_linewidth()
    vim.opt_local.textwidth = 0
end

local function no_fold()
    vim.opt_local.foldenable = false
    vim.opt_local.foldlevel = 19 -- hopefully enough to never auto-fold
end

local function main()
    infinite_linewidth()
    no_fold()
end
main()
