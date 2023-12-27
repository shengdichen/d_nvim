local function neodev()
    require("neodev").setup()
end

local function bind()
    local gid = vim.api.nvim_create_augroup("LspBind", { clear = true })

    -- quit quickfix
    vim.keymap.set("n", "<C-q>", function() vim.cmd("cclose") end)

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
        -- NOTE: (massive) slowdown/timeout with |completions| on
        --  https://github.com/python-lsp/python-lsp-server/issues/374
        completions = off,
        code_actions = on,
    }

    -- REF:
    --  https://github.com/python-lsp/pylsp-mypy#configuration
    c["pylsp-mypy"] = on

    -- checker & linter
    c["mccabe"] = on
    -- REF:
    --  https://black.readthedocs.io/en/stable/the_black_code_style/current_style.html#flake8
    -- NOTE:
    --  1. must specify this even if global flake8-config exists
    c["flake8"] = {
        enabled = true,
        maxLineLength = 88,
        ignore = {
            "E203", -- spaces around |:|
            "W503", -- binary-operator (e.g., +) at start-of-line
        }
    }
    -- https://github.com/python-lsp/python-lsp-ruff#configuration
    c["ruff"] = off -- use (separate) ruff_lsp instead
    c["pylint"] = off
    c["pyflakes"] = off
    c["pycodestyle"] = off
    c["pydocstyle"] = off

    -- formater
    c["black"] = on
    c["isort"] = on
    c["autopep8"] = off
    c["yapf"] = off

    return {
        cmd = {
            "pylsp",
            "--log-file",
            os.getenv("HOME") .. "/.local/state/nvim/pylsp.log",
        },
        settings = { pylsp = { plugins = c } },
    }
end

local function server_tsserver(cap)
    local c = {}
    c["capabilities"] = cap

    -- disable tsserver's formatting (use none_ls as configured below)
    c["on_attach"] = function(client, _)
        -- REF:
        --  https://neovim.discourse.group/t/how-to-config-multiple-lsp-for-document-hover/3093
        --  https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#serverCapabilities
        client.server_capabilities.documentFormattingProvider = false
    end

    return c
end

local function servers_default()
    return {
        "lua_ls", "hls", "clangd",
        "vimls",
        "bashls", "sqlls",
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

    conf["tsserver"].setup(server_tsserver(cap))

    for _, lang in ipairs(servers_default()) do
        conf[lang].setup({ capabilities = cap })
    end
end

local function border()
    local weight = "single"

    -- REF:
    --  :help lsp-handlers
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, { border = weight }
    )
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help, { border = weight }
    )
end

local function diagnostic()
    -- REF:
    --  https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization

    local function general()
        local c = {}

        c["virtual_text"] = {
            severity = vim.diagnostic.severity.ERROR, -- only for error(s)
            spacing = 0,
            prefix = "",
            format = function(d)
                -- REF:
                --  h: diagnostic-structure
                local msg = "<<" .. d.source
                if d.code then
                    return msg .. " [" .. d.code .. "]"
                end
                return msg
            end,
        }
        c["float"] = {
            border = "single",
            source = true,
        }
        c["signs"] = {
            severity = { min = vim.diagnostic.severity.INFO },
            priority = 2,
        }
        c["underline"] = false
        c["severity_sort"] = true

        vim.diagnostic.config(c)
    end

    local function gutter_sign()
        local d_str = "Diagnostic"
        local type_sign = { Error = "E ", Warn = "w ", Hint = "n ", Info = "i " }
        for type, sign in pairs(type_sign) do
            local hl_sign = d_str .. "Sign" .. type
            local hl_linenumber = "" -- will fallback to default-hl of line-number
            if type == "Error" or type == "Warn" then
                hl_linenumber = d_str .. type
            end
            vim.fn.sign_define(
                hl_sign, -- slight trickery: name the sign as the hl-group itself
                {
                    text = sign,
                    texthl = hl_sign,
                    numhl = hl_linenumber,
                }
            )
        end
    end

    general()
    gutter_sign()
end

local function none_ls()
    -- REF:
    --  https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md
    --  https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md

    local null_ls = require("null-ls")
    local sources = {}

    local function prose()
        local raws = {
            "text",
            "markdown", "rst",
        }
        local extras = { "mail", "tex", unpack(raws) }

        -- ltrs does NOT handle tex-keywords
        for _, s in ipairs({
            null_ls.builtins.diagnostics.ltrs,
            null_ls.builtins.code_actions.ltrs,
        }) do
            table.insert(sources, s.with({ filetypes = raws }))
        end

        for _, s in ipairs({
            null_ls.builtins.diagnostics.proselint,
            null_ls.builtins.code_actions.proselint,
            null_ls.builtins.diagnostics.alex,
            null_ls.builtins.diagnostics.write_good,
        }) do
            table.insert(sources, s.with({ filetypes = extras }))
        end
    end

    local function js()
        for _, s in ipairs({
            null_ls.builtins.code_actions.eslint_d,
            null_ls.builtins.diagnostics.eslint_d,

            null_ls.builtins.formatting.standardjs,
            null_ls.builtins.formatting.standardts,

            -- NOTE: alternative for |standardjs|
            --  null_ls.builtins.formatting.prettier_standard
            -- REF:
            --  https://standardjs.com/awesome#automatic-code-formatters
            --  https://github.com/sheerun/prettier-standard
        }) do
            table.insert(sources, s)
        end

        local function is_in(v, array)
            for _, vl in ipairs(array) do
                if v == vl then return true end
            end
            return false
        end

        local types_prettier = {}
        local types_to_remove = { "javascript", "javascriptreact", "typescript", "typescriptreact" }
        for _, t in ipairs(null_ls.builtins.formatting.prettierd.filetypes) do
            if not is_in(t, types_to_remove) then
                table.insert(types_prettier, t)
            end
        end
        table.insert(
            sources,
            null_ls.builtins.formatting.prettierd.with({ filetypes = types_prettier })
        )
    end

    local function shell()
        -- NOTE:
        --  use bash-language-server (with shellcheck) for linting

        table.insert(sources, null_ls.builtins.formatting.shfmt.with(
            {
                extra_args = {
                    "-i", "4", -- 4 spaces (not tabs)
                    "-ci"      -- indent case(s) of switch
                }
            }
        ))

        -- fallback if shfmt unavailable
        table.insert(sources, null_ls.builtins.formatting.beautysh.with(
            { disabled_filetypes = { "sh", "bash" } }
        ))

        table.insert(sources, null_ls.builtins.diagnostics.zsh)
    end

    prose()
    js()
    shell()
    null_ls.setup({ sources = sources })
end

local function main()
    neodev()
    bind()
    setup()
    border()
    diagnostic()
    none_ls()
end
main()
