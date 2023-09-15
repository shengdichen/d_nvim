local function visual()
    require("visual")["statusline"](2)

    require("cmd")["spell"](true, { "en" })()
end

local function bind()
    vim.keymap.set("c", "wq", "w <bar> qa", { buffer = 0 })
end

local function autocmd()
    local g = require("git")
    local augroup = g["augroup"]
    local layout_triple, layout_double = g["layout_triple"], g["layout_double"]

    vim.api.nvim_create_autocmd(
        { "VimEnter" },
        {
            group = augroup,
            pattern = { "COMMIT_EDITMSG" },
            callback = layout_triple
        }
    )
    vim.api.nvim_create_autocmd(
        { "VimEnter" },
        {
            group = augroup,
            pattern = { "TAG_EDITMSG" },
            callback = layout_double(true)
        }
    )
    vim.api.nvim_create_autocmd(
        { "VimEnter" },
        {
            group = augroup,
            pattern = { "MERGE_MSG" },
            callback = layout_double(false)
        }
    )
end

local function main()
    visual()
    bind()
    autocmd()
end
main()
