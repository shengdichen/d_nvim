local function visual()
    require("visual")["statusline"](2)

    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en"
end

local function bind()
    vim.keymap.set("c", "wq", "w <bar> qa", { buffer = 0 })
end

local function main()
    visual()
    bind()
end
main()
