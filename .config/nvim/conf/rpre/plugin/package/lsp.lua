local function bind()
    local gid = vim.api.nvim_create_augroup("LspBind", { clear = true })

    local function make_binds(args)
        vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        local opts = { buffer = args.buf }

        vim.keymap.set(
            "n",
            "<Leader>wl",
            function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
            opts
        )

        vim.keymap.set({ "n", "v" }, "<Leader>a", vim.lsp.buf.code_action, opts)

        vim.keymap.set("n", "<Leader>R", vim.lsp.buf.references, opts)

        vim.keymap.set("n", "<Leader>d", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "<Leader>D", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "<Leader><C-D>", vim.lsp.buf.type_definition, opts)

        vim.keymap.set("n", "<Leader>h", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<Leader>H", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<Leader>i", vim.lsp.buf.implementation, opts)

        vim.keymap.set("n", "<Leader>r", vim.lsp.buf.rename, opts)
        vim.keymap.set(
            "n",
            "<Leader>f",
            function() vim.lsp.buf.format({ async = true }) end,
            opts
        )
    end

    vim.api.nvim_create_autocmd(
        { "LspAttach" },
        { pattern = { "*" }, group = gid, callback = make_binds }
    )
end

local function python(conf)
    -- REF:
    --  https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md

    local on = { enabled = true }
    local off = { enabled = false }
    local c = {}

    -- formater
    c["black"] = on
    c["autopep8"] = off
    c["yapf"] = off

    conf.pylsp.setup({
        settings = { pylsp = { plugins = c } }
    })
end

local function lang()
    local conf = require("lspconfig")

    python(conf)
    conf.clangd.setup({})
    conf.tsserver.setup({})

    conf.lua_ls.setup({})
    conf.bashls.setup({})

    conf.sqlls.setup({})
    conf.vimls.setup({})
end

local function main()
    bind()
    lang()
end
main()
