local function bind()
    -- nnoremap <silent> <buffer> <Enter> :Man<CR>
    vim.keymap.set("n", "<Enter>", ":Man<CR>", { buffer = 0 })
end

local function main()
    bind()
end
main()
