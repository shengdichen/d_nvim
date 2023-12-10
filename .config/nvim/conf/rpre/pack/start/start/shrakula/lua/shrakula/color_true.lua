local function map_each(mapping, groups, color)
    for _, group in ipairs(groups) do
        mapping[group] = color
    end
end

local function normal(palette)
    return { bg = "none", fg = palette["white"] }
end

local function common(mapping, palette)
    local function general()
        mapping["Comment"] = { fg = palette["grey_bright"] }
        mapping["MatchParen"] = { fg = palette["cyan"], underline = true }
        mapping["EndOfBuffer"] = { fg = palette["black"] }                         -- tilde at EOF

        mapping["IncSearch"] = { bg = palette["white"], fg = palette["black"] }    -- current match
        mapping["Search"] = { bg = palette["grey_bright"], fg = palette["white"] } -- other matches

        mapping["Visual"] = { bg = palette["grey_bright"], fg = palette["black"] }
        mapping["VisualNOS"] = { bg = palette["grey_dark"], fg = "none" }

        -- notably used for diagnostics, e.g., lsp
        mapping["NormalFloat"] = { fg = palette["white"] }
        mapping["FloatBorder"] = { fg = palette["grey_bright"] }
    end

    local function cursor()
        mapping["Cursor"] = { fg = "none", reverse = true }
        mapping["CursorLine"] = { bg = palette["grey_dark"], fg = "none" }
        mapping["QuickFixLine"] = { bg = palette["grey_bright"], fg = palette["black"] }

        mapping["CursorLineNr"] = { fg = "fg", bold = true }    -- current
        mapping["LineNr"] = { fg = palette["grey_bright"] }     -- non-current

        mapping["CursorColumn"] = { fg = "fg", reverse = true } -- horizontal indicator for |cursorcolumn|
        mapping["ColorColumn"] = { bg = palette["grey_dark"], fg = "none" }
    end

    local function line_horizontal()
        mapping["StatusLine"] = { fg = "fg" }                     -- current
        mapping["StatusLineNC"] = { fg = palette["grey_bright"] } -- non-current

        mapping["Folded"] = { fg = palette["grey_bright"] }
        mapping["FoldColumn"] = { fg = palette["grey_bright"] }
        mapping["TabLine"] = { fg = palette["grey_bright"] } -- non-current
        mapping["TabLineFill"] = { fg = "none" }
    end

    local function cmd()
        mapping["WarningMsg"] = { fg = palette["orange"] }
        mapping["ErrorMsg"] = { fg = palette["red"] }
        mapping["Question"] = { fg = palette["purple"] }

        mapping["WildMenu"] = { fg = palette["grey_bright"] }
        mapping["Title"] = { fg = palette["cyan"] }

        mapping["PmenuSel"] = { bg = palette["white"], fg = palette["black"] }  -- selected
        mapping["Pmenu"] = { bg = palette["grey_dark"], fg = palette["white"] } -- non-selected
        mapping["PmenuSbar"] = { fg = palette["grey_dark"] }                    -- scrollbar
        mapping["PmenuThumb"] = { fg = palette["grey_bright"] }                 -- none

        mapping["Terminal"] = { fg = "none" }                                   -- cursor in builtin terminal
    end

    local function diff()
        mapping["DiffAdd"] = { fg = palette["green"] }
        mapping["DiffDelete"] = { fg = palette["red"] }

        -- lines with differences
        mapping["DiffChange"] = { bg = palette["grey_bright"], fg = palette["black"] }
        -- the differences themselves
        mapping["DiffText"] = { bg = palette["white"], fg = palette["black"] }
    end

    local function spellcheck()
        mapping["SpellCap"] = { fg = palette["yellow"] }
        mapping["SpellLocal"] = { fg = palette["yellow"] }
        mapping["SpellRare"] = { fg = palette["orange"] }

        mapping["SpellBad"] = { fg = palette["red"], underline = true }
    end

    local function misc()
        mapping["SignColumn"] = { bg = "none" }

        mapping["Directory"] = { fg = palette["cyan"] }

        mapping["VertSplit"] = { fg = palette["grey_bright"] }

        mapping["SpecialKey"] = { fg = palette["grey_bright"] }
        mapping["NonText"] = { fg = palette["grey_bright"] }
        mapping["Conceal"] = { fg = palette["grey_bright"] }
    end

    general()
    cursor()
    line_horizontal()
    cmd()
    diff()
    spellcheck()
    misc()
end

local function syntax(mapping, palette)
    local function internal()
        -- REF:
        --  |:help group-name|

        map_each(
            mapping,
            { "Constant", "String", "Character", "Number", "Boolean", "Float" },
            { fg = palette["green"] }
        )
        map_each(mapping, { "Identifier" }, { fg = "fg" })

        map_each(
            mapping,
            { "Statement", "Conditional", "Repeat", "Label", "Operator", "Keyword", "Exception" },
            { fg = palette["magenta"] }
        )

        map_each(
            mapping,
            { "Function", "PreProc", "Include", "Define", "Macro", "PreCondit" },
            { fg = palette["purple"] }
        )

        map_each(
            mapping,
            { "Type", "StorageClass", "Structure", "TypeDef" },
            { fg = palette["cyan"] }
        )

        map_each(
            mapping,
            { "Special", "SpecialChar", "Tag", "SpecialComment", "Debug" },
            { fg = palette["yellow"] }
        )

        mapping["Delimiter"] = { fg = palette["grey_bright"] }

        mapping["Underlined"] = { fg = "fg", underline = true }
        mapping["Ignore"] = { fg = palette["grey_dark"] }
        mapping["Error"] = { fg = palette["red"] }
        mapping["Todo"] = { fg = "fg", reverse = true }
    end

    local function diagnostic()
        -- REF
        --  |:help diagnostic-highlights|

        mapping["DiagnosticError"] = { fg = palette["red"] }
        mapping["DiagnosticWarn"] = { fg = palette["yellow"] }
        mapping["DiagnosticInfo"] = { fg = palette["grey_bright"] }
        mapping["DiagnosticHint"] = { fg = palette["grey_bright"] }
        mapping["DiagnosticOk"] = { fg = palette["grey_dark"] }

        -- Note
        --  1. *Sign* := gutter
        --  2. *Underline* := portion of code inducing the diagnostic
        --  3. *VirtualText* := inline message
        --  4. *Floating* := detail message
        mapping["DiagnosticSignError"] = { fg = palette["red"], reverse = true }

        map_each(
            mapping,
            {
                "DiagnosticSignError",
                "DiagnosticSignWarn",
                "DiagnosticSignInfo",
                "DiagnosticSignHint",
                "DiagnosticSignOk"
            },
            { link = "Normal" }
        )

        map_each(
            mapping,
            {
                "DiagnosticVirtualTextError",
                "DiagnosticVirtualTextWarn",
                "DiagnosticVirtualTextInfo",
                "DiagnosticVirtualTextHint",
                "DiagnosticVirtualTextOk"
            },
            { link = "Comment" }
        )

        map_each(
            mapping,
            {
                "DiagnosticFloatingError",
                "DiagnosticFloatingWarn",
                "DiagnosticFloatingInfo",
                "DiagnosticFloatingHint",
                "DiagnosticFloatingOk"
            },
            { link = "NormalFloat" }
        )
    end

    local function lsp()
        -- REF:
        --  |:help lsp-semantic-highlight|

        return 0
    end

    local function treesitter()
        -- REF:
        --  |:help treesitter-highlight-groups|

        mapping["@constructor"] = { link = "Type" }
        map_each(
            mapping,
            { "@field", "@property" },
            { fg = palette["blue"] }
        )
    end

    local function ibl()
        vim.api.nvim_set_hl(0, "IblIndent", { fg = palette["grey_darker"] })
    end

    internal()
    diagnostic()
    lsp()
    treesitter()
    ibl()
end

local function filetype(mapping, palette)
    local function debug()
        mapping["debugPc"] = { bg = palette["white"], fg = palette["black"] }
        mapping["debugBreakpoint"] = { bg = palette["red"], fg = "fg" }
    end

    local function gitsigns()
        map_each(
            mapping,
            {
                "GitSignsAdd",
                "GitSignsDelete",
                "GitSignsTopdelete",
                "GitSignsChange",
                "GitSignsChangedelete",
                "GitSignsUntracked",
            },
            { link = "Comment" }
        )
    end

    debug()
    gitsigns()
end

local function main()
    local function f(palette)
        -- define "Normal" first to allow shortcuts "fg"&"bg"
        vim.api.nvim_set_hl(0, "Normal", normal(palette))

        local mapping = {}
        common(mapping, palette)
        syntax(mapping, palette)
        filetype(mapping, palette)
        for item, color in pairs(mapping) do
            vim.api.nvim_set_hl(0, item, color)
        end
    end

    return f
end
return main()
