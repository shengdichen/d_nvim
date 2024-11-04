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

        vim.keymap.set("n", "<Leader>R", telescope_builtin.lsp_references, opts)

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
        if client then
            client.server_capabilities.semanticTokensProvider = nil
        end
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

local function lang()
    -- REF:
    --  https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    --  https://github.com/hrsh7th/nvim-cmp#recommended-configuration
    local m_lspconfig = require("lspconfig")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- REF:
    --  https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md
    --  https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md
    local m_nonels = require("null-ls")
    local sources_nonels = {}

    local function set_official(server, c)
        c = c or {}
        c["capabilities"] = capabilities
        m_lspconfig[server].setup(c)
    end

    local function set_nonels(servers, opts)
        for _, server in ipairs(servers) do
            if opts then
                table.insert(sources_nonels, server.with(opts))
            else
                table.insert(sources_nonels, server)
            end
        end
    end

    local function python(use_pyright)
        local function ruff()
            local c = {}

            -- disable hovering (use pyright)
            c["on_attach"] = function(client, _)
                -- REF:
                --  https://github.com/astral-sh/ruff-lsp?tab=readme-ov-file#example-neovim
                client.server_capabilities.hoverProvider = false
            end

            set_official("ruff_lsp", c)
        end

        local function pyright(use_based)
            -- NOTE:
            --  disable diagnostics in favor of ruff
            -- REF:
            --  https://github.com/astral-sh/ruff-lsp?tab=readme-ov-file#example-neovim

            local c = {}

            if use_based then
                -- REF:
                --  https://detachhead.github.io/basedpyright/#/settings
                c["settings"] = {
                    basedpyright = {
                        disableOrganizeImports = true, -- use ruff instead
                        analysis = {
                            ignore = { '*' },          -- use ruff instead
                        },
                    },
                }
                set_official("basedpyright", c)
                return
            end

            -- REF:
            --  https://microsoft.github.io/pyright/#/settings
            c["settings"] = {
                pyright = {
                    disableOrganizeImports = true,     -- use ruff instead
                },
                python = {
                    analysis = {
                        ignore = { '*' },     -- use ruff instead
                    },
                },
            }
            set_official("pyright", c)
        end

        local function nonels()
            set_nonels({
                m_nonels.builtins.diagnostics.mypy,
                m_nonels.builtins.diagnostics.pylint,
                m_nonels.builtins.formatting.isort,
            })
        end

        local function pylsp()
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
            -- https://github.com/python-lsp/python-lsp-ruff#configuration
            c["ruff"] = on
            c["pylint"] = on
            c["flake8"] = off
            c["pyflakes"] = off
            c["pycodestyle"] = off
            c["pydocstyle"] = off

            -- formatter
            c["black"] = off
            c["isort"] = off -- broken; use nonels-plugin instead
            c["autopep8"] = off
            c["yapf"] = off

            set_official("pylsp", {
                cmd = {
                    "pylsp",
                    "--log-file",
                    os.getenv("HOME") .. "/.local/state/nvim/pylsp.log",
                },
                settings = { pylsp = { plugins = c } },
            })

            set_nonels({
                m_nonels.builtins.formatting.isort,
            })
        end

        if use_pyright then
            ruff()
            pyright()
            nonels()
            return
        end
        pylsp()
    end

    local function csharp()
        local function omnisharp()
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

            set_official("omnisharp", c)
        end

        local function csharpier()
            set_nonels({ m_nonels.builtins.formatting.csharpier })
        end

        omnisharp()
        csharpier()
    end

    local function js()
        local function tsserver()
            local c = {}

            -- disable tsserver's formatting (use none_ls as configured below)
            c["on_attach"] = function(client, _)
                -- REF:
                --  https://neovim.discourse.group/t/how-to-config-multiple-lsp-for-document-hover/3093
                --  https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#serverCapabilities
                client.server_capabilities.documentFormattingProvider = false
            end

            set_official("tsserver", c)
        end

        local function nonels(as_server)
            -- NOTE (deprecated):
            --  null_ls.builtins.formatting.standardjs,
            --  null_ls.builtins.formatting.standardts,
            --  null_ls.builtins.formatting.prettier_standard (alternative for |standardjs|)
            -- REF:
            --  https://standardjs.com/awesome#automatic-code-formatters
            --  https://github.com/sheerun/prettier-standard

            local servers
            if as_server then
                servers = {
                    require("none-ls.code_actions.eslint_d"),
                    require("none-ls.diagnostics.eslint_d"),
                    require("none-ls.formatting.eslint_d"),
                    m_nonels.builtins.formatting.prettierd,
                }
            else
                servers = {
                    require("none-ls.code_actions.eslint"),
                    require("none-ls.diagnostics.eslint"),
                    require("none-ls.formatting.eslint"),
                    m_nonels.builtins.formatting.prettier,
                }
            end
            set_nonels(servers)
        end

        tsserver()
        nonels()
        set_official("eslint")
    end

    local function shell()
        local function nonels()
            -- NOTE:
            --  use bash-language-server (with shellcheck) for linting
            set_nonels(
                { m_nonels.builtins.formatting.shfmt },
                {
                    extra_args = {
                        "-i", "4", -- 4 spaces (not tabs)
                        "-ci"      -- indent case(s) of switch
                    }
                }
            )

            -- fallback if shfmt unavailable
            set_nonels(
                { require("none-ls.formatting.beautysh") },
                { disabled_filetypes = { "sh", "bash" } }
            )

            set_nonels({ m_nonels.builtins.diagnostics.zsh })
        end

        nonels()
        set_official("bashls")
    end

    local function java()
        -- set_official("java_language_server",
        --     {
        --         cmd = { os.getenv("HOME") .. "/.local/bin/java-language-server/dist/lang_server_linux.sh" },
        --     }
        -- )
        set_official("jdtls")
    end

    local function prose()
        local function nonels()
            set_nonels(
                {
                    m_nonels.builtins.diagnostics.proselint,
                    m_nonels.builtins.code_actions.proselint,
                },
                {
                    filetypes = {
                        "text", "markdown",
                        "html", "tex", "mail", "rst",
                    }
                })

            set_nonels(
                {
                    m_nonels.builtins.diagnostics.textlint,
                    m_nonels.builtins.formatting.textlint,
                },
                {
                    filetypes = {
                        "text", "markdown",
                        "html", "tex" -- extra plugins
                    }
                }
            )
            -- make up for types unsupported by textlint
            set_nonels({
                    m_nonels.builtins.diagnostics.alex,
                    m_nonels.builtins.diagnostics.write_good,
                },
                { filetypes = { "mail", "rst" } }
            )
        end

        nonels()
        set_official("ltex")
        set_official("texlab")
    end

    local function misc()
        require("neodev").setup()

        local function refactoring()
            local m_refactoring = require("refactoring")
            ---@diagnostic disable-next-line: missing-parameter
            m_refactoring.setup()

            set_nonels(m_nonels.builtins.code_actions.refactoring)
            vim.keymap.set("c", ":R", "lua vim.lsp.buf.code_action()")

            local m_telescope = require("telescope")
            m_telescope.load_extension("refactoring")
            vim.keymap.set(
                { "n", "x" },
                "<Leader>e",
                function()
                    m_telescope.extensions.refactoring.refactors()
                end
            )
        end
        refactoring()

        for _, server in ipairs(
            {
                "lua_ls", "hls", "clangd", "zls",
                "cssls", "html", "jsonls", -- vscode-extracted family
                "vimls",
                "sqlls",
            }
        ) do
            set_official(server)
        end
    end

    python()
    csharp()
    js()
    shell()
    java()
    prose()
    misc()

    m_nonels.setup({ sources = sources_nonels })
end

local function visual()
    local function diagnostic()
        -- REF:
        --  https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization

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
        c["underline"] = true
        c["severity_sort"] = true

        vim.diagnostic.config(c)
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

    local function gutter_sign()
        local d_str = "Diagnostic"
        local d_types = { "Error", "Warn", "Hint", "Info" }
        for _, d_type in ipairs(d_types) do
            local hl_sign = d_str .. "Sign" .. d_type
            local hl_linenumber = d_str .. d_type
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
            if count == 1 then return message end
            return string.format("%d%s", count, message)
        end

        -- lsp-item
        local function progress_format_annotation(msg)
            if msg.title then return "[" .. msg.title .. "]" end
            return "[]"
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

    diagnostic()
    border()
    gutter_sign()
    fidget()
end

local function main()
    lang()
    bind()
    visual()
end
main()
