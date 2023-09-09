local function bind()
    -- nnoremap <silent> <buffer> <Enter> :Man<CR>
    vim.keymap.set("n", "<Enter>", ":Man<CR>", { buffer = 0 })
end

local function visual()
    -- set to nil to use global value
    vim.opt_local.number = nil
    vim.opt_local.relativenumber = nil
end

local function main()
    bind()
    visual()
end
main()
