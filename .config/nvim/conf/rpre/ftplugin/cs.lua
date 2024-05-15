local function bind()
    -- REF:
    --  https://github.com/Hoffs/omnisharp-extended-lsp.nvim?tab=readme-ov-file#how-to-use

    local opts = { buffer = 0 }
    local omnisharp = require('omnisharp_extended')

    vim.keymap.set("n", "<Leader>R", function()
        omnisharp.telescope_lsp_references()
    end, opts)

    vim.keymap.set("n", "<Leader>d", function()
        omnisharp.telescope_lsp_definition({ jump_type = "vsplit" })
    end, opts)
    vim.keymap.set("n", "<Leader>D", function()
        omnisharp.telescope_lsp_type_definition()
    end, opts)

    vim.keymap.set("n", "<Leader>i", function()
        omnisharp.telescope_lsp_implementation()
    end, opts)
end
bind()
