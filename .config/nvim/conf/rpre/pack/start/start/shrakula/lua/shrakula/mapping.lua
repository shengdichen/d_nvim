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
        mapping["DiffChange"] = { bg = "none", fg = palette["pink"] }

        mapping["DiffText"] = { bg = "none", fg = palette["white_dark"] }
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
        mapping["Constant"] = { bg = "none", fg = palette["green"] }
        mapping["String"] = { bg = "none", fg = palette["green"] }
        mapping["Character"] = { bg = "none", fg = palette["green"] }
        mapping["Number"] = { bg = "none", fg = palette["green"] }
        mapping["Boolean"] = { bg = "none", fg = palette["green"] }
        mapping["Float"] = { bg = "none", fg = palette["green"] }

        mapping["Identifier"] = { bg = "none", fg = palette["cyan"] }
        mapping["Function"] = { bg = "none", fg = palette["cyan"] }

        mapping["Statement"] = { bg = "none", fg = palette["purple"] }
        mapping["Conditional"] = { bg = "none", fg = palette["purple"] }
        mapping["Repeat"] = { bg = "none", fg = palette["purple"] }
        mapping["Label"] = { bg = "none", fg = palette["purple"] }
        mapping["Operator"] = { bg = "none", fg = palette["purple"] }
        mapping["Keyword"] = { bg = "none", fg = palette["purple"] }
        mapping["Exception"] = { bg = "none", fg = palette["purple"] }

        mapping["PreProc"] = { bg = "none", fg = palette["purple"] }
        mapping["Include"] = { bg = "none", fg = palette["purple"] }
        mapping["Define"] = { bg = "none", fg = palette["purple"] }
        mapping["Macro"] = { bg = "none", fg = palette["purple"] }
        mapping["PreCondit"] = { bg = "none", fg = palette["purple"] }

        mapping["Type"] = { bg = "none", fg = palette["pink"] }
        mapping["StorageClass"] = { bg = "none", fg = palette["pink"] }
        mapping["Structure"] = { bg = "none", fg = palette["pink"] }
        mapping["TypeDef"] = { bg = "none", fg = palette["pink"] }

        mapping["Special"] = { bg = "none", fg = palette["yellow"] }
        mapping["Specialchar"] = { bg = "none", fg = palette["yellow"] }
        mapping["Tag"] = { bg = "none", fg = palette["yellow"] }
        mapping["Delimtiter"] = { bg = "none", fg = palette["yellow"] }
        mapping["SpecialComment"] = { bg = "none", fg = palette["yellow"] }
        mapping["Debug"] = { bg = "none", fg = palette["yellow"] }

        mapping["Underlined"] = { bg = "none", fg = "fg", underline = true }
        mapping["Ignore"] = { bg = "none", fg = palette["black_bright"] }
        mapping["Error"] = { bg = "none", fg = palette["red"] }
        mapping["Todo"] = { bg = "none", fg = "fg", reverse = true }
    end

    local function lsp()
        mapping["@lsp.type.class"] = { fg = palette.cyan }
        mapping["@lsp.type.enum"] = { fg = palette.cyan }
        mapping["@lsp.type.decorator"] = { fg = palette.green }
        mapping["@lsp.type.enumMember"] = { fg = palette.purple }
        mapping["@lsp.type.function"] = { fg = palette.green, }
        mapping["@lsp.type.interface"] = { fg = palette.cyan }
        mapping["@lsp.type.macro"] = { fg = palette.cyan }
        mapping["@lsp.type.method"] = { fg = palette.green, }
        mapping["@lsp.type.namespace"] = { fg = palette.orange, }
        mapping["@lsp.type.parameter"] = { fg = palette.orange, }
        mapping["@lsp.type.property"] = { fg = palette.purple, }
        mapping["@lsp.type.struct"] = { fg = palette.cyan }
        mapping["@lsp.type.type"] = { fg = palette.bright_cyan, }
        mapping["@lsp.type.variable"] = { fg = palette.fg, }

        mapping["DiagnosticError"] = { fg = palette.red, }
        mapping["DiagnosticWarn"] = { fg = palette.yellow, }
        mapping["DiagnosticInfo"] = { fg = palette.cyan, }
        mapping["DiagnosticHint"] = { fg = palette.cyan, }
        mapping["DiagnosticUnderlineError"] = { undercurl = true, sp = palette.red, }
        mapping["DiagnosticUnderlineWarn"] = { undercurl = true, sp = palette.yellow, }
        mapping["DiagnosticUnderlineInfo"] = { undercurl = true, sp = palette.cyan, }
        mapping["DiagnosticUnderlineHint"] = { undercurl = true, sp = palette.cyan, }
        mapping["DiagnosticSignError"] = { fg = palette.red, }
        mapping["DiagnosticSignWarn"] = { fg = palette.yellow, }
        mapping["DiagnosticSignInfo"] = { fg = palette.cyan, }
        mapping["DiagnosticSignHint"] = { fg = palette.cyan, }
        mapping["DiagnosticFloatingError"] = { fg = palette.red, }
        mapping["DiagnosticFloatingWarn"] = { fg = palette.yellow, }
        mapping["DiagnosticFloatingInfo"] = { fg = palette.cyan, }
        mapping["DiagnosticFloatingHint"] = { fg = palette.cyan, }
        mapping["DiagnosticVirtualTextError"] = { fg = palette.red, }
        mapping["DiagnosticVirtualTextWarn"] = { fg = palette.yellow, }
        mapping["DiagnosticVirtualTextInfo"] = { fg = palette.cyan, }
        mapping["DiagnosticVirtualTextHint"] = { fg = palette.cyan, }

        mapping["LspDiagnosticsDefaultError"] = { fg = palette.red, }
        mapping["LspDiagnosticsDefaultWarning"] = { fg = palette.yellow, }
        mapping["LspDiagnosticsDefaultInformation"] = { fg = palette.cyan, }
        mapping["LspDiagnosticsDefaultHint"] = { fg = palette.cyan, }
        mapping["LspDiagnosticsUnderlineError"] = { fg = palette.red, undercurl = true, }
        mapping["LspDiagnosticsUnderlineWarning"] = { fg = palette.yellow, undercurl = true, }
        mapping["LspDiagnosticsUnderlineInformation"] = { fg = palette.cyan, undercurl = true, }
        mapping["LspDiagnosticsUnderlineHint"] = { fg = palette.cyan, undercurl = true, }
        mapping["LspReferenceText"] = { fg = palette.orange, }
        mapping["LspReferenceRead"] = { fg = palette.orange, }
        mapping["LspReferenceWrite"] = { fg = palette.orange, }
        mapping["LspCodeLens"] = { fg = palette.cyan, }
    end

    local function treesitter()
        mapping["@error"] = { fg = palette.bright_red, }
        mapping["@punctuation.delimiter"] = { fg = palette.fg, }
        mapping["@punctuation.bracket"] = { fg = palette.fg, }
        mapping["@punctuation.special"] = { fg = palette.cyan, }

        mapping["@constant"] = { fg = palette.purple, }
        mapping["@constant.builtin"] = { fg = palette.purple, }
        mapping["@symbol"] = { fg = palette.purple, }

        mapping["@constant.macro"] = { fg = palette.cyan, }
        mapping["@string.regex"] = { fg = palette.red, }
        mapping["@string"] = { fg = palette.yellow, }
        mapping["@string.escape"] = { fg = palette.cyan, }
        mapping["@character"] = { fg = palette.green, }
        mapping["@number"] = { fg = palette.purple, }
        mapping["@boolean"] = { fg = palette.purple, }
        mapping["@float"] = { fg = palette.green, }
        mapping["@annotation"] = { fg = palette.yellow, }
        mapping["@attribute"] = { fg = palette.cyan, }
        mapping["@namespace"] = { fg = palette.orange, }

        mapping["@function.builtin"] = { fg = palette.cyan, }
        mapping["@function"] = { fg = palette.green, }
        mapping["@function.macro"] = { fg = palette.green, }
        mapping["@parameter"] = { fg = palette.orange, }
        mapping["@parameter.reference"] = { fg = palette.orange, }
        mapping["@method"] = { fg = palette.green, }
        mapping["@field"] = { fg = palette.orange, }
        mapping["@property"] = { fg = palette.purple, }
        mapping["@constructor"] = { fg = palette.cyan, }

        mapping["@conditional"] = { fg = palette.pink, }
        mapping["@repeat"] = { fg = palette.pink, }
        mapping["@label"] = { fg = palette.cyan, }

        mapping["@keyword"] = { fg = palette.pink, }
        mapping["@keyword.function"] = { fg = palette.cyan, }
        mapping["@keyword.function.ruby"] = { fg = palette.pink, }
        mapping["@keyword.operator"] = { fg = palette.pink, }
        mapping["@operator"] = { fg = palette.pink, }
        mapping["@exception"] = { fg = palette.purple, }
        mapping["@type"] = { fg = palette.bright_cyan, }
        mapping["@type.builtin"] = { fg = palette.cyan, italic = true, }
        mapping["@type.qualifier"] = { fg = palette.pink, }
        mapping["@structure"] = { fg = palette.purple, }
        mapping["@include"] = { fg = palette.pink, }

        mapping["@variable"] = { fg = palette.fg, }
        mapping["@variable.builtin"] = { fg = palette.purple, }

        mapping["@text"] = { fg = palette.orange, }
        mapping["@text.strong"] = { fg = palette.orange, bold = true, }     -- bold
        mapping["@text.emphasis"] = { fg = palette.yellow, italic = true, } -- italic
        mapping["@text.underline"] = { fg = palette.orange, }
        mapping["@text.title"] = { fg = palette.pink, bold = true, }        -- title
        mapping["@text.literal"] = { fg = palette.yellow, }                 -- inline code
        mapping["@text.uri"] = { fg = palette.yellow, italic = true, }      -- urls
        mapping["@text.reference"] = { fg = palette.orange, bold = true, }

        mapping["@tag"] = { fg = palette.cyan, }
        mapping["@tag.attribute"] = { fg = palette.green, }
        mapping["@tag.delimiter"] = { fg = palette.cyan, }
    end

    local function semantic()
        mapping["@class"] = { fg = palette.cyan }
        mapping["@struct"] = { fg = palette.cyan }
        mapping["@enum"] = { fg = palette.cyan }
        mapping["@enumMember"] = { fg = palette.purple }
        mapping["@event"] = { fg = palette.cyan }
        mapping["@interface"] = { fg = palette.cyan }
        mapping["@modifier"] = { fg = palette.cyan }
        mapping["@regexp"] = { fg = palette.yellow }
        mapping["@typeParameter"] = { fg = palette.cyan }
        mapping["@decorator"] = { fg = palette.cyan }
    end

    internal()
    lsp()
    treesitter()
    semantic()
end

local function filetype(mapping, palette)
    local function html()
        mapping["htmlArg"] = { fg = palette.green, }
        mapping["htmlBold"] = { fg = palette.yellow, bold = true, }
        mapping["htmlEndTag"] = { fg = palette.cyan, }
        mapping["htmlH0"] = { fg = palette.pink, }
        mapping["htmlH1"] = { fg = palette.pink, }
        mapping["htmlH2"] = { fg = palette.pink, }
        mapping["htmlH3"] = { fg = palette.pink, }
        mapping["htmlH4"] = { fg = palette.pink, }
        mapping["htmlH5"] = { fg = palette.pink, }
        mapping["htmlItalic"] = { fg = palette.purple, italic = true, }
        mapping["htmlLink"] = { fg = palette.purple, underline = true, }
        mapping["htmlSpecialChar"] = { fg = palette.yellow, }
        mapping["htmlSpecialTagName"] = { fg = palette.cyan, }
        mapping["htmlTag"] = { fg = palette.cyan, }
        mapping["htmlTagN"] = { fg = palette.cyan, }
        mapping["htmlTagName"] = { fg = palette.cyan, }
        mapping["htmlTitle"] = { fg = palette.white, }
    end

    local function markdown()
        mapping["markdownBlockquote"] = { fg = palette.yellow, italic = true, }
        mapping["markdownBold"] = { fg = palette.orange, bold = true, }
        mapping["markdownCode"] = { fg = palette.green, }
        mapping["markdownCodeBlock"] = { fg = palette.orange, }
        mapping["markdownCodeDelimiter"] = { fg = palette.red, }
        mapping["markdownH1"] = { fg = palette.pink, bold = true, }
        mapping["markdownH2"] = { fg = palette.pink, bold = true, }
        mapping["markdownH3"] = { fg = palette.pink, bold = true, }
        mapping["markdownH4"] = { fg = palette.pink, bold = true, }
        mapping["markdownH5"] = { fg = palette.pink, bold = true, }
        mapping["markdownH6"] = { fg = palette.pink, bold = true, }
        mapping["markdownHeadingDelimiter"] = { fg = palette.red, }
        mapping["markdownHeadingRule"] = { fg = palette.comment, }
        mapping["markdownId"] = { fg = palette.purple, }
        mapping["markdownIdDeclaration"] = { fg = palette.cyan, }
        mapping["markdownIdDelimiter"] = { fg = palette.purple, }
        mapping["markdownItalic"] = { fg = palette.yellow, italic = true, }
        mapping["markdownLinkDelimiter"] = { fg = palette.purple, }
        mapping["markdownLinkText"] = { fg = palette.pink, }
        mapping["markdownListMarker"] = { fg = palette.cyan, }
        mapping["markdownOrderedListMarker"] = { fg = palette.red, }
        mapping["markdownRule"] = { fg = palette.comment, }
    end

    local function diff()
        mapping["diffAdded"] = { fg = palette.green, }
        mapping["diffRemoved"] = { fg = palette.red, }
        mapping["diffFileId"] = { fg = palette.yellow, bold = true, reverse = true, }
        mapping["diffFile"] = { fg = palette.nontext, }
        mapping["diffNewFile"] = { fg = palette.green, }
        mapping["diffOldFile"] = { fg = palette.red, }
    end

    local function debug()
        mapping["debugPc"] = { bg = palette.menu, }
        mapping["debugBreakpoint"] = { fg = palette.red, reverse = true, }
    end

    html()
    markdown()
    diff()
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
