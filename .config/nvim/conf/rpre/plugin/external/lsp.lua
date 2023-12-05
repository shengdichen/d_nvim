local function bind()
    local gid = vim.api.nvim_create_augroup("LspBind", { clear = true })

    vim.keymap.set("n", "<Leader>p", vim.diagnostic.open_float)
    vim.keymap.set("n", "<Leader>P", vim.diagnostic.setloclist)
    vim.keymap.set("n", "<Leader>k", vim.diagnostic.goto_prev)
    vim.keymap.set("n", "<Leader>j", vim.diagnostic.goto_next)

    local function make_binds(args)
        local opts = { buffer = args.buf }

        vim.keymap.set(
            "n",
            "<Leader>wl",
            function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
            opts
        )

        vim.keymap.set({ "n", "v" }, "<Leader>a", vim.lsp.buf.code_action, opts)

        vim.keymap.set("n", "<Leader>R", vim.lsp.buf.references, opts)

        vim.keymap.set("n", "<Leader>d", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "<Leader>D", vim.lsp.buf.declaration, opts)
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

local function server_pyls()
    -- REF:
    --  https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md

    local on = { enabled = true }
    local off = { enabled = false }
    local c = {}

    -- REF:
    --  https://github.com/python-lsp/python-lsp-server/blob/develop/docs/autoimport.md
    c["rope_autoimport"] = {
        completions = off, -- only seems to slow down completion
        code_actions = on
    }

    -- REF:
    --  https://github.com/python-lsp/pylsp-mypy#configuration
    c["pylsp-mypy"] = on

    -- checker & linter
    c["mccabe"] = on
    -- https://black.readthedocs.io/en/stable/the_black_code_style/current_style.html#flake8
    c["flake8"] = { enabled = true, maxLineLength = 88, ignore = { "E203" } }
    c["pylint"] = off
    c["pyflakes"] = off
    c["pycodestyle"] = off
    c["pydocstyle"] = off

    -- formater
    c["black"] = on
    c["isort"] = on
    c["autopep8"] = off
    c["yapf"] = off

    return { settings = { pylsp = { plugins = c } } }
end

local function servers_default()
    return {
        -- "ruff_lsp", -- https://github.com/python-lsp/python-lsp-ruff#configuration
        "lua_ls", "hls", "clangd",
        "vimls",
        "tsserver", "bashls", "sqlls"
    }
end

local function setup()
    -- REF:
    --  https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    --  https://github.com/hrsh7th/nvim-cmp#recommended-configuration

    local conf = require("lspconfig")
    local cap = require("cmp_nvim_lsp").default_capabilities()

    local c_python = server_pyls()
    c_python["capabilities"] = cap
    conf["pylsp"].setup(c_python)

    for _, lang in ipairs(servers_default()) do
        conf[lang].setup({ capabilities = cap })
    end
end

local function main()
    bind()
    setup()
end
main()
