local function visual()
    vim.opt_local.laststatus = 2 -- show full status-line

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
