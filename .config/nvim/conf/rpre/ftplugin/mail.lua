local function spell()
    require("internal")["spell"](true, { "en", "fr", "de" })()
end

local function append_space_signature()
    local function append_space()
        local pos = vim.api.nvim_win_get_cursor(0)
        vim.cmd("%s/^--$/-- /e")
        vim.api.nvim_win_set_cursor(0, pos)
    end

    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
        pattern = { "*" },
        callback = append_space,
    })
end

local function main()
    spell()
    append_space_signature()
end
main()
