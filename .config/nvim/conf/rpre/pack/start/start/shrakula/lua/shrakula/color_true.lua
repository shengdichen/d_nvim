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
        mapping["NormalFloat"] = { bg = "none", fg = palette["white"] }
        mapping["Comment"] = { bg = "none", fg = palette["grey_bright"] }
        mapping["MatchParen"] = { bg = "none", fg = palette["cyan"], underline = true }
        mapping["EndOfBuffer"] = { bg = "none", fg = palette["black"] }            -- tilde at EOF

        mapping["IncSearch"] = { bg = palette["white"], fg = palette["black"] }    -- current match
        mapping["Search"] = { bg = palette["grey_bright"], fg = palette["white"] } -- other matches

        mapping["Visual"] = { bg = palette["grey_bright"], fg = palette["black"] }
        mapping["VisualNOS"] = { bg = palette["grey_dark"], fg = "none" }
    end

    local function cursor()
        mapping["Cursor"] = { bg = "none", fg = "none", reverse = true }
        mapping["CursorLine"] = { bg = palette["grey_dark"], fg = "none" }
        mapping["QuickFixLine"] = { bg = palette["yellow"], fg = palette["black"] }

        mapping["CursorLineNr"] = { bg = "none", fg = "fg", bold = true }    -- current
        mapping["LineNr"] = { bg = "none", fg = palette["grey_bright"] }     -- non-current

        mapping["CursorColumn"] = { bg = "none", fg = "fg", reverse = true } -- horizontal indicator for |cursorcolumn|
        mapping["ColorColumn"] = { bg = palette["grey_dark"], fg = "none" }
    end

    local function line_horizontal()
        mapping["StatusLine"] = { bg = "none", fg = "fg" }                     -- current
        mapping["StatusLineNC"] = { bg = "none", fg = palette["grey_bright"] } -- non-current

        mapping["Folded"] = { bg = "none", fg = palette["grey_bright"] }
        mapping["FoldColumn"] = { bg = "none", fg = palette["grey_bright"] }
        mapping["TabLine"] = { bg = "none", fg = palette["grey_bright"] } -- non-current
        mapping["TabLineFill"] = { bg = "none", fg = "none" }
    end

    local function cmd()
        mapping["WarningMsg"] = { bg = "none", fg = palette["orange"] }
        mapping["ErrorMsg"] = { bg = "none", fg = palette["red"] }
        mapping["Question"] = { bg = "none", fg = palette["purple"] }

        mapping["WildMenu"] = { bg = "none", fg = palette["grey_bright"] }
        mapping["Title"] = { bg = "none", fg = palette["cyan"] }

        mapping["PmenuSel"] = { bg = palette["white"], fg = palette["black"] }  -- selected
        mapping["Pmenu"] = { bg = palette["grey_dark"], fg = palette["white"] } -- non-selected
        mapping["PmenuSbar"] = { bg = "none", fg = palette["grey_dark"] }       -- scrollbar
        mapping["PmenuThumb"] = { bg = "none", fg = palette["grey_bright"] }    -- none

        mapping["Terminal"] = { bg = "none", fg = "none" }                      -- cursor in builtin terminal
    end

    local function diff()
        mapping["DiffAdd"] = { bg = "none", fg = palette["green"] }
        mapping["DiffDelete"] = { bg = "none", fg = palette["red"] }

        -- lines with differences
        mapping["DiffChange"] = { bg = palette["grey_bright"], fg = palette["black"] }
        -- the differences themselves
        mapping["DiffText"] = { bg = palette["white"], fg = palette["black"] }
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

        mapping["VertSplit"] = { bg = "none", fg = palette["grey_bright"] }

        mapping["SpecialKey"] = { bg = "none", fg = palette["grey_bright"] }
        mapping["NonText"] = { bg = "none", fg = palette["grey_bright"] }
        mapping["Conceal"] = { bg = "none", fg = palette["grey_bright"] }

        mapping["FloatBorder"] = { bg = "none", fg = palette["grey_bright"] }
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
            { bg = "none", fg = palette["green"] }
        )
        map_each(mapping, { "Identifier" }, { bg = "none", fg = "fg" })

        map_each(
            mapping,
            { "Statement", "Conditional", "Repeat", "Label", "Operator", "Keyword", "Exception" },
            { bg = "none", fg = palette["magenta"] }
        )

        map_each(
            mapping,
            { "Function", "PreProc", "Include", "Define", "Macro", "PreCondit" },
            { bg = "none", fg = palette["purple"] }
        )

        map_each(
            mapping,
            { "Type", "StorageClass", "Structure", "TypeDef" },
            { bg = "none", fg = palette["cyan"] }
        )

        map_each(
            mapping,
            { "Special", "SpecialChar", "Tag", "SpecialComment", "Debug" },
            { bg = "none", fg = palette["yellow"] }
        )

        mapping["Delimiter"] = { bg = "none", fg = palette["grey_bright"] }

        mapping["Underlined"] = { bg = "none", fg = "fg", underline = true }
        mapping["Ignore"] = { bg = "none", fg = palette["grey_dark"] }
        mapping["Error"] = { bg = "none", fg = palette["red"] }
        mapping["Todo"] = { bg = "none", fg = "fg", reverse = true }
    end

    local function diagnostic()
        -- REF
        --  |:help diagnostic-highlights|

        mapping["DiagnosticError"] = { bg = "none", fg = palette["red"] }
        mapping["DiagnosticWarn"] = { bg = "none", fg = palette["yellow"] }
        mapping["DiagnosticInfo"] = { bg = "none", fg = palette["grey_bright"] }
        mapping["DiagnosticHint"] = { bg = "none", fg = palette["grey_bright"] }
        mapping["DiagnosticOk"] = { bg = "none", fg = palette["grey_dark"] }
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
            { bg = "none", fg = palette["blue"] }
        )
    end

    internal()
    diagnostic()
    lsp()
    treesitter()
end

local function filetype(mapping, palette)
    local function debug()
        mapping["debugPc"] = { bg = palette["white"], fg = palette["black"] }
        mapping["debugBreakpoint"] = { bg = palette["red"], fg = "fg" }
    end

    debug()
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
