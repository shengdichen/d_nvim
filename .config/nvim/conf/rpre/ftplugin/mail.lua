local function spell()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en,fr,de"
end

local function main()
    spell()
end
main()
