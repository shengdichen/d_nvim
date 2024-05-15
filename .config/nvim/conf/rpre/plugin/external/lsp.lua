local function neodev()
    require("neodev").setup()
end

local function fidget()
    -- NOTE:
    --  1. jargon
    --  ->  group := lsp-server
    --  ->  annote/annotation := actual lsp-item
    --  2. item construction:
    --  |render_message|->|format_message| |space| |format_annote|

    local function progress_format_message(msg)
        local res = ">"
        if msg.message then
            res = msg.message .. res
        end
        return res
    end

    -- further format message from progress_format_message()
    local function render_message(message, count)
        if count == 1 then
            return message
        else
            return string.format("%d%s", count, message)
        end
    end

    -- lsp-item
    local function progress_format_annotation(msg)
        if msg.title then
            return "[" .. msg.title .. "]"
        else
            return "[]"
        end
    end

    -- lsp-server
    local function progress_format_group(group)
        return "// " .. tostring(group)
    end

    local c = {
        progress = {
            poll_rate = 0.25,
            ignore_done_already = true,

            display = {
                -- items completed
                done_ttl = 2,
                done_icon = "",
                done_style = "Comment",

                -- items in progress
                progress_ttl = math.huge, -- do NOT auto-hide
                progress_icon = "...",
                progress_style = "Normal",

                icon_style = "Normal", -- icons of done&progress

                format_group_name = progress_format_group,
                group_style = "Comment",

                format_message = progress_format_message,
                format_annote = progress_format_annotation,
            },
        },

        notification = {
            poll_rate = 1,
            history_size = 37,

            view = {
                stack_upwards = false,
                icon_separator = "", -- specify separator directly in |*_icon|

                group_separator = "|",
                group_separator_hl = "Comment",

                render_message = render_message,
            },

            window = {
                normal_hl = "Comment",
                winblend = 0, -- fully transparent
                border = "single",
                border_hl = "Comment",

                y_padding = 1,
                x_padding = 2,
                align = "top",
            },
        },
    }

    require("fidget").setup(c)
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
        local telescope_builtin = require("telescope.builtin")

        vim.keymap.set(
            "n",
            "<Leader>wl",
            function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
            opts
        )

        vim.keymap.set({ "n", "v" }, "<Leader>a", vim.lsp.buf.code_action, opts)

        vim.keymap.set("n", "<Leader>R", require("telescope.builtin").lsp_references, opts)

        -- definition := .c[pp]
        -- declaration := .h[pp]
        vim.keymap.set("n", "<Leader>d", function()
            telescope_builtin.lsp_definitions({ jump_type = "split" })
        end, opts)
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

    local function no_highlight(args)
        -- REF
        --  |h: vim.lsp.semantic_tokens.start()|
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        client.server_capabilities.semanticTokensProvider = nil
    end

    vim.api.nvim_create_autocmd(
        { "LspAttach" },
        {
            pattern = { "*" },
            group = gid,
            callback = function(args)
                make_binds(args)
                no_highlight(args)
            end
        }
    )
end

local function server_pylsp(cap)
    -- REF:
    --  https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md

    local c = {}
    local on = { enabled = true }
    local off = { enabled = false }

    -- REF:
    --  https://github.com/python-lsp/python-lsp-server/blob/develop/docs/autoimport.md
    c["rope_autoimport"] = {
        -- NOTE: (massive) slowdown/timeout with |completions| on
        --  https://github.com/python-lsp/python-lsp-server/issues/374
        enabled = false,

        -- potential settings
        --  completions = off,
        --  code_actions = on,
        --  memory = true,
    }
    c["rope_completion"] = off

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
    c["pylint"] = on
    c["pyflakes"] = off
    c["pycodestyle"] = off
    c["pydocstyle"] = off

    -- formater
    c["black"] = on
    c["isort"] = on
    c["autopep8"] = off
    c["yapf"] = off

    return {
        capabilities = cap,
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

local function server_omnisharp(cap)
    local c = {}

    c["cmd"] = { "dotnet", "/usr/lib/omnisharp/OmniSharp.dll" }
    c["settings"] = {
        FormattingOptions = {
            EnableEditorConfigSupport = true,
            OrganizeImports = true,
        },
        RoslynExtensionsOptions = {
            -- Enables support for roslyn analyzers, code fixes and rulesets.
            EnableAnalyzersSupport = true,
            -- Enables support for showing unimported types and unimported extension
            -- methods in completion lists. When committed, the appropriate using
            -- directive will be added at the top of the current file. This option can
            -- have a negative impact on initial completion responsiveness,
            -- particularly for the first few completion sessions after opening a
            -- solution.
            EnableImportCompletion = true,
            -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
            -- true
            AnalyzeOpenDocumentsOnly = true,
        },
    }
    c["capabilities"] = cap

    return c
end

local function servers_default()
    return {
        "lua_ls", "hls", "clangd",
        "eslint", "cssls", "html", "jsonls", -- vscode-extracted family
        "vimls",
        "bashls", "sqlls",
        "ltex"
    }
end

local function setup()
    -- REF:
    --  https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    --  https://github.com/hrsh7th/nvim-cmp#recommended-configuration

    local conf = require("lspconfig")
    local cap = require("cmp_nvim_lsp").default_capabilities()

    conf["pylsp"].setup(server_pylsp(cap))
    conf["tsserver"].setup(server_tsserver(cap))
    conf["omnisharp"].setup(server_omnisharp(cap))

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
                local msg = "<<" .. (d.source or " ?") -- e.g. jsonls contains no |source|
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
        local type_sign = { "Error", "Warn", "Hint", "Info" }
        for _, type in ipairs(type_sign) do
            local hl_sign = d_str .. "Sign" .. type
            local hl_linenumber = d_str .. type
            vim.fn.sign_define(
                hl_sign,       -- slight trickery: name the sign as the hl-group itself
                {
                    text = "", -- do NOT show any text in gutter
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
            require("none-ls.code_actions.eslint_d"),
            require("none-ls.diagnostics.eslint_d"),
            require("none-ls.formatting.eslint_d"),

            null_ls.builtins.formatting.prettier,
            null_ls.builtins.formatting.prettierd,

            -- NOTE (deprecated):
            --  null_ls.builtins.formatting.standardjs,
            --  null_ls.builtins.formatting.standardts,
            --  null_ls.builtins.formatting.prettier_standard (alternative for |standardjs|)
            -- REF:
            --  https://standardjs.com/awesome#automatic-code-formatters
            --  https://github.com/sheerun/prettier-standard
        }) do
            table.insert(sources, s)
        end
    end

    local function csharp()
        table.insert(sources, null_ls.builtins.formatting.csharpier)
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
        table.insert(sources, require("none-ls.formatting.beautysh").with(
            { disabled_filetypes = { "sh", "bash" } }
        ))

        table.insert(sources, null_ls.builtins.diagnostics.zsh)
    end

    prose()
    js()
    csharp()
    shell()
    null_ls.setup({ sources = sources })
end

local function main()
    neodev()
    fidget()
    bind()
    setup()
    border()
    diagnostic()
    none_ls()
end
main()
