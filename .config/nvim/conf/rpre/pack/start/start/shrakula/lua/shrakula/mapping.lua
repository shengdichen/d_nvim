local function map_each(mapping, groups, color)
    for _, group in ipairs(groups) do
        mapping[group] = color
    end
end

local function normal(palette)
    return { bg = "none", fg = palette["white_bright"] }
end

local function common(mapping, palette)
    local function general()
        mapping["NormalFloat"] = { bg = "none", fg = palette["white_bright"] }
        mapping["Comment"] = { bg = "none", fg = palette["white_dark"] }
        mapping["MatchParen"] = { bg = "none", fg = palette["cyan"], underline = true }
        mapping["EndOfBuffer"] = { bg = "none", fg = palette["black_dark"] }                -- tilde at EOF

        mapping["IncSearch"] = { bg = palette["white_bright"], fg = palette["black_dark"] } -- current match
        mapping["Search"] = { bg = palette["white_dark"], fg = palette["white_bright"] }    -- other matches

        mapping["Visual"] = { bg = palette["black_bright"], fg = "none" }
        mapping["VisualNOS"] = { bg = palette["black_bright"], fg = "none" }
    end

    local function cursor()
        mapping["Cursor"] = { bg = "none", fg = "none", reverse = true }
        mapping["CursorLine"] = { bg = palette["black_bright"], fg = "none" }
        mapping["QuickFixLine"] = { bg = palette["yellow"], fg = palette["black_dark"] }

        mapping["CursorLineNr"] = { bg = "none", fg = "fg", bold = true }    -- current
        mapping["LineNr"] = { bg = "none", fg = palette["white_dark"] }      -- non-current

        mapping["CursorColumn"] = { bg = "none", fg = "fg", reverse = true } -- horizontal indicator for |cursorcolumn|
        mapping["ColorColumn"] = { bg = palette["black_bright"], fg = "none" }
    end

    local function line_horizontal()
        mapping["StatusLine"] = { bg = "none", fg = "fg" }                    -- current
        mapping["StatusLineNC"] = { bg = "none", fg = palette["white_dark"] } -- non-current

        mapping["Folded"] = { bg = "none", fg = palette["white_dark"] }
        mapping["FoldColumn"] = { bg = "none", fg = palette["white_dark"] }
        mapping["TabLine"] = { bg = "none", fg = palette["white_dark"] } -- non-current
        mapping["TabLineFill"] = { bg = "none", fg = "none" }
    end

    local function cmd()
        mapping["WarningMsg"] = { bg = "none", fg = palette["orange"] }
        mapping["ErrorMsg"] = { bg = "none", fg = palette["bright_red"] }
        mapping["Question"] = { bg = "none", fg = palette["purple"] }

        mapping["WildMenu"] = { bg = "none", fg = palette["white_dark"] }
        mapping["Title"] = { bg = "none", fg = palette["cyan"] }

        mapping["PmenuSel"] = { bg = palette["white_bright"], fg = palette["black_dark"] } -- selected
        mapping["Pmenu"] = { bg = palette["black_bright"], fg = palette["white_bright"] }  -- non-selected
        mapping["PmenuSbar"] = { bg = "none", fg = palette["black_bright"] }               -- scrollbar
        mapping["PmenuThumb"] = { bg = "none", fg = palette["white_dark"] }                -- none

        mapping["Terminal"] = { bg = "none", fg = "none" }                                 -- cursor in builtin terminal
    end

    local function diff()
        mapping["DiffAdd"] = { bg = "none", fg = palette["green"] }
        mapping["DiffDelete"] = { bg = "none", fg = palette["red"] }

        -- lines with differences
        mapping["DiffChange"] = { bg = palette["white_dark"], fg = palette["black_dark"] }
        -- the differences themselves
        mapping["DiffText"] = { bg = palette["white_bright"], fg = palette["black_dark"] }
    end

    local function spellcheck()
        mapping["SpellCap"] = { bg = "none", fg = palette["yellow"] }
        mapping["SpellLocal"] = { bg = "none", fg = palette["yellow"] }
        mapping["SpellRare"] = { bg = "none", fg = palette["orange"] }

        mapping["SpellBad"] = { bg = "none", fg = palette["red"], underline = true }
    end

    local function misc()
        mapping["SignColumn"] = { bg = "none" }

        mapping["Directory"] = { bg = "none", fg = palette["cyan"] }

        mapping["VertSplit"] = { bg = "none", fg = palette["white_dark"] }

        mapping["SpecialKey"] = { bg = "none", fg = palette["white_dark"] }
        mapping["NonText"] = { bg = "none", fg = palette["white_dark"] }
        mapping["Conceal"] = { bg = "none", fg = palette["white_dark"] }

        mapping["FloatBorder"] = { bg = "none", fg = palette["white"] }
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
            { bg = "none", fg = palette["orange"] }
        )
        map_each(mapping, { "Identifier" }, { bg = "none", fg = palette["green"] })

        map_each(
            mapping,
            { "Statement", "Conditional", "Repeat", "Label", "Operator", "Keyword", "Exception" },
            { bg = "none", fg = palette["cyan"] }
        )

        map_each(
            mapping,
            { "Function", "PreProc", "Include", "Define", "Macro", "PreCondit" },
            { bg = "none", fg = palette["purple"] }
        )

        map_each(
            mapping,
            { "Type", "StorageClass", "Structure", "TypeDef" },
            { bg = "none", fg = palette["pink"] }
        )

        map_each(
            mapping,
            { "Special", "Specialchar", "Tag", "Delimtiter", "SpecialComment", "Debug" },
            { bg = "none", fg = palette["yellow"] }
        )

        mapping["Underlined"] = { bg = "none", fg = "fg", underline = true }
        mapping["Ignore"] = { bg = "none", fg = palette["black_bright"] }
        mapping["Error"] = { bg = "none", fg = palette["red"] }
        mapping["Todo"] = { bg = "none", fg = "fg", reverse = true }
    end

    local function diagnostic()
        -- REF
        --  |:help diagnostic-highlights|

        mapping["DiagnosticError"] = { bg = "none", fg = palette["red"] }
        mapping["DiagnosticWarn"] = { bg = "none", fg = palette["yellow"] }
        mapping["DiagnosticInfo"] = { bg = "none", fg = palette["white_bright"] }
        mapping["DiagnosticHint"] = { bg = "none", fg = palette["white_dark"] }
        mapping["DiagnosticOk"] = { bg = "none", fg = palette["black_bright"] }
    end

    local function lsp()
        -- REF:
        --  |:help lsp-semantic-highlight|

        return 0
    end

    local function treesitter()
        -- REF:
        --  |:help treesitter-highlight-groups|

        return 0
    end

    internal()
    diagnostic()
    lsp()
    treesitter()
end

local function filetype(mapping, palette)
    local function debug()
        mapping["debugPc"] = { bg = palette.menu, }
        mapping["debugBreakpoint"] = { fg = palette.red, reverse = true, }
    end

    debug()
end

local function main()
    local function f(palette)
        local mapping = {}

        common(mapping, palette)
        syntax(mapping, palette)
        filetype(mapping, palette)

        return normal(palette), mapping
    end

    return f
end
return main()
