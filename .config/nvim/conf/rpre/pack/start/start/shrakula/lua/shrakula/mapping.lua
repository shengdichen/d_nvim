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

local function unused(mapping, palette)
    local function lsp_saga()
        mapping["LspFloatWinNormal"] = { fg = palette.fg, }
        mapping["LspFloatWinBorder"] = { fg = palette.comment, }
        mapping["LspSagaHoverBorder"] = { fg = palette.comment, }
        mapping["LspSagaSignatureHelpBorder"] = { fg = palette.comment, }
        mapping["LspSagaCodeActionBorder"] = { fg = palette.comment, }
        mapping["LspSagaDefPreviewBorder"] = { fg = palette.comment, }
        mapping["LspLinesDiagBorder"] = { fg = palette.comment, }
        mapping["LspSagaRenameBorder"] = { fg = palette.comment, }
        mapping["LspSagaBorderTitle"] = { fg = palette.menu, }
        mapping["LSPSagaDiagnosticTruncateLine"] = { fg = palette.comment, }
        mapping["LspSagaDiagnosticBorder"] = { fg = palette.comment, }
        mapping["LspSagaShTruncateLine"] = { fg = palette.comment, }
        mapping["LspSagaDocTruncateLine"] = { fg = palette.comment, }
        mapping["LspSagaLspFinderBorder"] = { fg = palette.comment, }
        mapping["CodeActionNumber"] = { bg = 'NONE', fg = palette.cyan }
    end

    local function completion()
        -- Nvim compe
        mapping["CmpItemAbbrDeprecated"] = { fg = palette.white, bg = palette.menu, }
        mapping["CmpItemAbbrMatch"] = { fg = palette.cyan, bg = palette.menu, }

        -- Compe
        mapping["CompeDocumentation"] = { link = "Pmenu" }
        mapping["CompeDocumentationBorder"] = { link = "Pmenu" }

        -- Cmp
        mapping["CmpItemKind"] = { link = "Pmenu" }
        mapping["CmpItemAbbr"] = { link = "Pmenu" }
        mapping["CmpItemKindMethod"] = { link = "@method" }
        mapping["CmpItemKindText"] = { link = "@text" }
        mapping["CmpItemKindFunction"] = { link = "@function" }
        mapping["CmpItemKindConstructor"] = { link = "@type" }
        mapping["CmpItemKindVariable"] = { link = "@variable" }
        mapping["CmpItemKindClass"] = { link = "@type" }
        mapping["CmpItemKindInterface"] = { link = "@type" }
        mapping["CmpItemKindModule"] = { link = "@namespace" }
        mapping["CmpItemKindProperty"] = { link = "@property" }
        mapping["CmpItemKindOperator"] = { link = "@operator" }
        mapping["CmpItemKindReference"] = { link = "@parameter.reference" }
        mapping["CmpItemKindUnit"] = { link = "@field" }
        mapping["CmpItemKindValue"] = { link = "@field" }
        mapping["CmpItemKindField"] = { link = "@field" }
        mapping["CmpItemKindEnum"] = { link = "@field" }
        mapping["CmpItemKindKeyword"] = { link = "@keyword" }
        mapping["CmpItemKindSnippet"] = { link = "@text" }
        mapping["CmpItemKindColor"] = { link = "DevIconCss" }
        mapping["CmpItemKindFile"] = { link = "TSURI" }
        mapping["CmpItemKindFolder"] = { link = "TSURI" }
        mapping["CmpItemKindEvent"] = { link = "@constant" }
        mapping["CmpItemKindEnumMember"] = { link = "@field" }
        mapping["CmpItemKindConstant"] = { link = "@constant" }
        mapping["CmpItemKindStruct"] = { link = "@structure" }
        mapping["CmpItemKindTypeParameter"] = { link = "@parameter" }
    end

    lsp_saga()
    completion()
end

local function main(load_unused)
    local function f(palette)
        local mapping = {}

        common(mapping, palette)
        syntax(mapping, palette)
        filetype(mapping, palette)
        if load_unused then
            unused(mapping, palette)
        end

        return normal(palette), mapping
    end

    return f
end
return main(false)
