local c = {}
local cmp = require("cmp")
local luasnip = require("luasnip")

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

    c["mapping"] = cmp.mapping.preset.insert(c_map)
end

local function main()
    snippet()
    source()
    map()

    cmp.setup(c)
end
main()
