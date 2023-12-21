local c = {}
local cmp = require("cmp")
local luasnip = require("luasnip")

local function snippets_collection()
    local spt = luasnip.snippet
    local n_sn = luasnip.snippet_node
    local n_is = luasnip.indent_snippet_node

    local n_t = luasnip.text_node
    local line_break = function(count)
        local text = {}
        for _ = 0, count do
            table.insert(text, "")
        end
        return n_t(text)
    end
    local tab = function(count)
        local text = string.rep(" ", count * 4)
        return n_t(text)
    end
    local n_i = luasnip.insert_node
    local n_f = luasnip.function_node

    local n_c = luasnip.choice_node
    local n_d = luasnip.dynamic_node
    local n_r = luasnip.restore_node

    local s_sh = {
        spt("var",
            n_c(1, {
                { n_t({ '"${' }), n_i(1, "var?"), n_t({ '}"' }), },
                { n_t({ "${" }),  n_i(1, "var?"), n_t({ "}" }), },
            })
        ),
        spt("v#",
            n_c(1, {
                { n_t({ '"${#}"' }) },
                { n_t({ "${#}" }) },
            })
        ),
        spt("v1",
            n_c(1, {
                { n_t({ '"${1}"' }) },
                { n_t({ "${1}" }) },
            })
        ),
        spt("v2",
            n_c(1, {
                { n_t({ '"${2}"' }) },
                { n_t({ "${2}" }) },
            })
        ),
        spt("v3",
            n_c(1, {
                { n_t({ '"${3}"' }) },
                { n_t({ "${3}" }) },
            })
        ),
        spt("v@",
            n_c(1, {
                { n_t({ '"${@}"' }) },
                { n_t({ "${@}" }) },
            })
        ),
        spt("v*",
            n_c(1, {
                { n_t({ '"${*}"' }) },
                { n_t({ "${*}" }) },
            })
        ),

        spt("fn",
            {
                n_i(1, "fn?"), n_t({ "() {" }),
                line_break(1),
                tab(1), n_i(2, "what?"),
                line_break(1),
                n_t({ "}" }),
                line_break(1),
            }
        ),
        spt("sub",
            {
                n_t({ "(" }),
                line_break(1),
                tab(1), n_i(1, "what?"),
                line_break(1),
                n_t({ ")" }),
                line_break(1),
            }
        ),
        spt("cd",
            n_c(1, {
                {
                    n_t({ "cd " }), n_i(1, "where?"), n_t({ " || exit " }), n_i(2, "3"),
                    line_break(1),
                },
                {
                    n_t({ "cd " }), n_i(1, "where?"), n_t({ " && " }), n_i(2, "what?"),
                },
            })
        ),

        --  if $1; then
        --      $0
        --  fi
        spt("if",
            {
                n_t({ "if " }), n_i(1, "test?"), n_t({ "; then" }),
                line_break(1),
                tab(1), n_i(2, "what?"),
                line_break(1),
                n_t({ "fi" }),
                line_break(1),
            }
        ),
        spt("if--",
            { n_t({ 'if [ "${1}" = "--" ]; then shift; fi' }), }
        ),

        spt("tt",
            { n_t({ "[ " }), n_i(1, "test?"), n_t({ " ]" }), }
        ),
        -- test: os
        spt("te",
            n_c(1, {
                { n_t({ "[ -e " }),   n_i(1, "path?"), n_t({ " ]" }), },
                { n_t({ "[ ! -e " }), n_i(1, "path?"), n_t({ " ]" }), },
            })
        ),
        spt("tf",
            n_c(1, {
                { n_t({ "[ -f " }),   n_i(1, "path?"), n_t({ " ]" }), },
                { n_t({ "[ ! -f " }), n_i(1, "path?"), n_t({ " ]" }), },
            })
        ),
        spt("td",
            n_c(1, {
                { n_t({ "[ -d " }),   n_i(1, "path?"), n_t({ " ]" }), },
                { n_t({ "[ ! -d " }), n_i(1, "path?"), n_t({ " ]" }), },
            })
        ),
        --  test: string
        spt("tstr",
            n_c(1, {
                { n_t({ "[ " }),   n_i(1, "str?"), n_t({ " ]" }), },
                { n_t({ "[ ! " }), n_i(1, "str?"), n_t({ " ]" }), },
            })
        ),
        spt("tstrtrue",
            { n_t({ "[ -n " }), n_i(1, "str?"), n_t({ " ]" }), }
        ),
        spt("tstrfalse",
            { n_t({ "[ -z " }), n_i(1, "str?"), n_t({ " ]" }), }
        ),
        spt("tstr==",
            { n_t({ "[ " }), n_i(1, "str?"), n_t({ " = " }), n_i(2, "value"), n_t({ " ]" }), }
        ),
        spt("tstr!=",
            { n_t({ "[ " }), n_i(1, "str?"), n_t({ " != " }), n_i(2, "value"), n_t({ " ]" }), }
        ),
        -- test: algebraic
        spt("t==",
            { n_t({ "[ " }), n_i(1, "var?"), n_t({ " -eq " }), n_i(2, "value"), n_t({ " ]" }), }
        ),
        spt("t!=",
            { n_t({ "[ " }), n_i(1, "var?"), n_t({ " -ne " }), n_i(2, "value"), n_t({ " ]" }), }

        ),
        spt("t>",
            { n_t({ "[ " }), n_i(1, "var?"), n_t({ " -gt " }), n_i(2, "value"), n_t({ " ]" }), }
        ),
        spt("t>=",
            { n_t({ "[ " }), n_i(1, "var?"), n_t({ " -ge " }), n_i(2, "value"), n_t({ " ]" }), }
        ),
        spt("t<",
            { n_t({ "[ " }), n_i(1, "var?"), n_t({ " -lt " }), n_i(2, "value"), n_t({ " ]" }), }
        ),
        spt("t<=",
            { n_t({ "[ " }), n_i(1, "var?"), n_t({ " -le " }), n_i(2, "value"), n_t({ " ]" }), }
        ),

        spt("while",
            {
                n_t("while "), n_i(1, "test?"), n_t("; do"),
                line_break(1),
                tab(1), n_i(2, "what?"),
                line_break(1),
                n_t("done"),
                line_break(1),
                n_i(0)
            }
        ),
        spt("case",
            {
                n_t("case "), n_i(1, "var?"), n_t(" in"),
                line_break(1),

                tab(1), n_t('"'), n_i(2, "val1?"), n_t('")'),
                line_break(1),
                tab(2), n_i(3, "what?"),
                line_break(1),
                tab(2), n_t(";;"),
                line_break(1),

                tab(1), n_t('"'), n_i(4, "val2?"), n_t('")'),
                line_break(1),
                tab(2), n_i(5, "what?"),
                line_break(1),
                tab(2), n_t(";;"),
                line_break(1),

                tab(1), n_t("*)"),
                line_break(1),
                tab(2), n_i(6, "exit 3"),
                line_break(1),
                tab(2), n_t(";;"),
                line_break(1),

                n_t("esac"),
                line_break(1),
                n_i(0)
            }
        ),

        spt("shebang",
            {
                n_t({ "#!/usr/bin/env " }), n_i(1, "da"), n_t({ "sh" }),
                line_break(1),
            }
        ),

    }
    luasnip.add_snippets("sh", s_sh)

    local s_mail = {
        spt("dear",
            {
                n_t({ "Dear " }), n_i(1, "who?"), n_t({ ":" }),
                line_break(2),
                n_i(0, "what?"),
            }
        ),
        spt("dear_sir",
            { n_t({ "Dear Sir or Madam:" }), line_break(2), }
        ),
        spt("dear_mishra",
            { n_t({ "Dear Sir or Madam:" }), line_break(2), }
        ),

        spt("thank_mail",
            { n_t({ "Thank you for your E-Mail. " }), }
        ),
        spt("thank_fast", {
            n_t({ "Thank you for the swift response. " })
        }),
    }
    luasnip.add_snippets("mail", s_mail)
end

local function snippet()
    c["snippet"] = {
        expand = function(args) luasnip.lsp_expand(args.body) end
    }

    -- use rafamadriz/friendly-snippets as source
    -- REF:
    --  https://github.com/L3MON4D3/LuaSnip#add-snippets
    require("luasnip.loaders.from_vscode").lazy_load()
end

local function source()
    c["sources"] = cmp.config.sources({
        { name = "luasnip" },
        { name = "nvim_lsp" }
    })
end

local function jump_luasnip(positive_jump)
    local j = positive_jump and 1 or -1

    return function(builtin)
        if cmp.visible() then
            if positive_jump then
                cmp.select_next_item()
            else
                cmp.select_prev_item()
            end
        elseif luasnip.expandable() or luasnip.jumpable(j) then
            luasnip.jump(j)
        else
            builtin() -- fallback: pass the key through
        end
    end
end

local function scroll_doc(positive_dir)
    return function(builtin)
        if cmp.visible() then
            cmp.scroll_docs(positive_dir and 1 or -1)
        else
            builtin() -- fallback: pass the key through
        end
    end
end

local function map()
    local c_map = {}

    c_map["<c-p>"] = cmp.mapping(jump_luasnip(false))
    c_map["<c-n>"] = cmp.mapping(jump_luasnip(true))
    c_map["<c-k>"] = cmp.mapping(scroll_doc(false))
    c_map["<c-j>"] = cmp.mapping(scroll_doc(true))

    c_map["<c-space>"] = cmp.mapping.complete()
    c_map["<cr>"] = cmp.mapping.confirm({
        cmp.ConfirmBehavior.Insert,
        select = true -- use first item if nothing selected
    })
    c_map["<c-e>"] = cmp.mapping.abort()

    vim.keymap.set(
        { "i", "s" },
        "<c-r>",
        function()
            if luasnip.choice_active() then
                luasnip.change_choice(1)
            end
        end,
        { silent = true }
    )

    c["mapping"] = cmp.mapping.preset.insert(c_map)
end

local function main()
    snippets_collection()
    snippet()
    source()
    map()

    cmp.setup(c)
end
main()
