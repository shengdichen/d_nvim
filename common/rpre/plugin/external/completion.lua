local c_cmp = {}
local m_cmp = require("cmp")
local m_luasnip = require("luasnip")

local function general()
    c_cmp["sources"] = m_cmp.config.sources({
        { name = "luasnip" },
        { name = "nvim_lsp" }
    })

    c_cmp["snippet"] = {
        expand = function(args) m_luasnip.lsp_expand(args.body) end
    }

    -- use rafamadriz/friendly-snippets as source
    -- REF:
    --  https://github.com/L3MON4D3/LuaSnip#add-snippets
    require("luasnip.loaders.from_vscode").lazy_load()
end

local function bind()
    local c = {}

    local function scroll_doc(positive_dir)
        return function(builtin)
            if m_cmp.visible() then
                m_cmp.scroll_docs(positive_dir and 1 or -1)
            else
                builtin() -- fallback: pass the key through
            end
        end
    end
    c["<Up>"] = m_cmp.mapping(scroll_doc(false))
    c["<Down>"] = m_cmp.mapping(scroll_doc(true))

    c["<c-space>"] = m_cmp.mapping.complete()
    c["<cr>"] = m_cmp.mapping.confirm({
        m_cmp.ConfirmBehavior.Insert,
        select = true -- use first item if nothing selected
    })
    c["<c-e>"] = m_cmp.mapping.abort()

    local function jump_luasnip(positive_jump, _)
        local jump = positive_jump and 1 or -1
        local movement = positive_jump and "j" or "k"

        return function(_)
            if m_luasnip.locally_jumpable(jump) then
                m_luasnip.jump(jump)
            else
                vim.cmd("normal " .. movement)
            end
        end
    end
    vim.keymap.set(
        { "i", "s" },
        "<c-k>",
        jump_luasnip(false),
        { silent = true }
    )
    vim.keymap.set(
        { "i", "s" },
        "<c-j>",
        jump_luasnip(true),
        { silent = true }
    )

    local function scroll_choice(positive_dir)
        return function(_)
            if m_luasnip.choice_active() then
                m_luasnip.change_choice(positive_dir and 1 or -1)
            end
        end
    end
    vim.keymap.set(
        { "i", "s" },
        "<c-r>",
        scroll_choice(false)
    )
    vim.keymap.set(
        { "i", "s" },
        "<c-t>",
        scroll_choice(true)
    )

    c_cmp["mapping"] = m_cmp.mapping.preset.insert(c)
end

local function main()
    general()
    bind()

    m_cmp.setup(c_cmp)
end
main()
