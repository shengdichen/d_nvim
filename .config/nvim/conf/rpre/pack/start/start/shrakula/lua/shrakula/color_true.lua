local mapping = {}

---@param groups string[]
---@param color table<string, string>
local function map_each(groups, color)
    for _, group in ipairs(groups) do
        mapping[group] = color
    end
end

local function common(palette)
    -- REF:
    --  :h guifg
    -- NOTE:
    --  a.  passthrough, i.e., use deduction from syntax/treesitter
    --  ->  do NOT specify OR "NONE"
    --  b.  any fixed color (e.g., if we want to ignore hl-deduction)
    --  ->  specify explicitly (if same as |Normal|, consider using "fg")

    local function general()
        mapping["Comment"] = { fg = palette["grey_bright"] }
        mapping["MatchParen"] = { fg = palette["cyan"], underline = true }
        mapping["EndOfBuffer"] = { fg = palette["black"] }                      -- tilde at EOF

        mapping["IncSearch"] = { bg = palette["white"], fg = palette["black"] } -- current match
        mapping["Search"] = { bg = palette["grey_bright"], fg = "fg" }          -- other matches

        mapping["Visual"] = { bg = palette["grey_bright"], fg = palette["black"] }
        mapping["VisualNOS"] = { bg = palette["grey_dark"], fg = "fg" }

        -- notably used for diagnostics, e.g., lsp
        mapping["NormalFloat"] = { link = "Normal" }
        mapping["FloatBorder"] = { link = "Comment" }
    end

    local function cursor()
        mapping["Cursor"] = { reverse = true }                -- the single point of the cursor
        mapping["CursorLine"] = { bg = palette["grey_dark"] } -- the entire line that the cursor is on
        mapping["QuickFixLine"] = { bg = palette["grey_bright"], fg = palette["black"] }

        mapping["CursorLineNr"] = { link = "Normal" } -- current
        mapping["LineNr"] = { link = "Comment" }      -- non-current

        mapping["CursorColumn"] = { reverse = true }  -- horizontal indicator for |cursorcolumn|
        mapping["ColorColumn"] = { bg = palette["grey_dark"] }
    end

    local function line_horizontal()
        mapping["StatusLine"] = { link = "Normal" }    -- current
        mapping["StatusLineNC"] = { link = "Comment" } -- non-current

        mapping["Folded"] = { link = "Comment" }
        mapping["FoldColumn"] = { link = "Comment" }
        mapping["TabLine"] = { link = "Comment" } -- non-current
        mapping["TabLineFill"] = { link = "Normal" }
    end

    local function cmd()
        mapping["WarningMsg"] = { fg = palette["orange"] }
        mapping["ErrorMsg"] = { fg = palette["red"] }
        mapping["Question"] = { fg = palette["purple"] }

        mapping["WildMenu"] = { link = "Comment" }
        mapping["Title"] = { fg = palette["cyan"] }

        mapping["PmenuSel"] = { bg = palette["white"], fg = palette["black"] } -- selected
        mapping["Pmenu"] = { bg = palette["grey_dark"] }                       -- non-selected
        mapping["PmenuSbar"] = { fg = palette["grey_dark"] }                   -- scrollbar
        mapping["PmenuThumb"] = { link = "Comment" }                           -- none

        mapping["Terminal"] = { fg = "NONE" }                                  -- cursor in builtin terminal
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
        -- sign-column(s) for rows without sign(s)
        mapping["SignColumn"] = { link = "Normal" }

        mapping["Directory"] = { fg = palette["cyan"] }

        mapping["VertSplit"] = { link = "Comment" }

        mapping["SpecialKey"] = { link = "Comment" }
        mapping["NonText"] = { link = "Comment" }
        mapping["Conceal"] = { link = "Comment" }
    end

    general()
    cursor()
    line_horizontal()
    cmd()
    diff()
    spellcheck()
    misc()
end

local function syntax(palette)
    local function internal()
        -- REF:
        --  |:help group-name|

        map_each(
            { "String", "Character", "Number", "Boolean", "Float" },
            { fg = palette["green"] }
        )
        map_each({ "Identifier" }, { link = "Normal" })

        map_each(
            { "Statement", "Conditional", "Repeat", "Label", "Operator", "Keyword", "Exception" },
            { fg = palette["magenta"] }
        )

        map_each(
            { "Function", "PreProc", "Include", "Define", "Macro", "PreCondit" },
            { fg = palette["purple"] }
        )

        map_each(
            { "Type", "StorageClass", "Structure", "TypeDef" },
            { fg = palette["cyan"] }
        )

        map_each(
            { "Constant", "Special", "SpecialChar", "Tag", "SpecialComment", "Debug" },
            { fg = palette["yellow"] }
        )

        mapping["Delimiter"] = { link = "Comment" }

        mapping["Underlined"] = { fg = "fg", underline = true }
        mapping["Ignore"] = { fg = palette["grey_dark"] }
        mapping["Error"] = { fg = palette["red"] }
        mapping["Todo"] = { bg = palette["grey_bright"], fg = palette["black"] }
    end

    local function diagnostic()
        -- REF
        --  |:help diagnostic-highlights|

        local bg = "#433f4b" -- slightly brighter than grey-dark
        mapping["DiagnosticError"] = { bg = bg, fg = palette["red"] }
        mapping["DiagnosticWarn"] = { bg = bg, fg = palette["yellow"] }
        map_each(
            {
                "DiagnosticInfo",
                "DiagnosticHint",
                "DiagnosticOk"
            },
            { bg = bg }
        )

        -- Note
        --  1. *Sign* := gutter
        --  2. *Underline* := portion of code inducing the diagnostic
        --  3. *VirtualText* := inline message
        --  4. *Floating* := detail message
        map_each(
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

    local function treesitter()
        -- REF:
        --  |:help treesitter-highlight-groups|

        map_each(
            { "@keyword.luadoc", "@keyword.return.luadoc" },
            { link = "Comment" }
        )

        -- tune down $() and ${} in particular
        map_each(
            { "@punctuation.special.bash" },
            { link = "Delimiter" }
        )

        mapping["@keyword.import"] = { link = "@include" }

        mapping["@constructor"] = { link = "Type" }

        mapping["@text.uri"] = { underline = true }
        mapping["@string.special.url"] = { link = "@text.uri" }

        map_each(
            { "@comment.note", "@comment.todo", "@comment.warning", "@comment.error" },
            { link = "Todo" }
        )

        map_each(
            { "@field", "@property", "@variable.member" },
            { fg = palette["blue"] }
        )
    end

    local function lsp()
        -- REF:
        --  |:help lsp-semantic-highlight|

        mapping["@lsp.type.namespace"] = { link = "@namespace" }
        mapping["@lsp.type.interface"] = { link = "@structure" }
        mapping["@lsp.type.struct"] = { link = "@structure" }
        mapping["@lsp.type.class"] = { link = "@structure" }
        mapping["@lsp.type.enum"] = { link = "@structure" }
        mapping["@lsp.type.enumMember"] = { link = "@constant" }

        mapping["@lsp.type.type"] = { link = "@type" }
        mapping["@lsp.type.typeParameter"] = { link = "@type.definition" }

        mapping["@lsp.type.function"] = { link = "@function" }
        mapping["@lsp.type.method"] = { link = "@method" }
        mapping["@lsp.type.decorator"] = { link = "@method" }
        mapping["@lsp.type.parameter"] = { link = "@parameter" }

        mapping["@lsp.type.variable"] = { link = "@variable" }
        mapping["@lsp.type.property"] = { link = "@property" }
        mapping["@lsp.type.macro"] = { link = "@macro" }
    end

    local function cmp()
        -- type of complemention, e.g., function, snippet...
        mapping["CmpItemKind"] = { link = "Comment" }
    end

    local function ibl()
        mapping["IblIndent"] = {
            fg = "#27232b" -- slightly darker than grey-dark
        }
    end

    internal()
    diagnostic()
    lsp()
    treesitter()
    cmp()
    ibl()
end

local function filetype(palette)
    local function debug()
        mapping["debugPc"] = { bg = palette["white"], fg = palette["black"] }
        mapping["debugBreakpoint"] = { bg = palette["red"], fg = "fg" }
    end

    local function gitsigns()
        map_each(
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

    local function telescope()
        mapping["TelescopeBorder"] = { link = "Comment" }
        mapping["TelescopeTitle"] = { link = "Comment" }

        -- prompt
        mapping["TelescopePromptPrefix"] = { link = "Comment" }
        mapping["TelescopePromptCounter"] = { link = "Comment" } -- <num>/<num> on RHS

        -- picker
        mapping["TelescopeSelectionCaret"] = { link = "Comment" } -- caret
        mapping["TelescopeSelection"] = { link = "CursorLine" }   -- the current line
        mapping["TelescopeMatching"] = { link = "IncSearch" }     -- matching part
        mapping["TelescopeMultiSelection"] = { link = "Visual" }  -- all selected lines
        map_each(
            {
                "TelescopeResultsSpecialComment", -- e.g., line-number when searching current buffer
                "TelescopeResultsNumber",         -- e.g., buffer id
                "TelescopeResultsComment",        -- e.g., buffer type (%a, #h...)
            },
            { link = "Comment" }
        )

        -- preview
        mapping["TelescopePreviewLine"] = { link = "Visual" }     -- the current line
        mapping["TelescopePreviewMatch"] = { link = "IncSearch" } -- matching part
    end

    debug()
    gitsigns()
    telescope()
end

local function main()
    local function f(palette)
        -- define "Normal" first to allow shortcuts "fg"&"bg"
        vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", fg = palette["white"] })

        common(palette)
        syntax(palette)
        filetype(palette)
        for item, color in pairs(mapping) do
            vim.api.nvim_set_hl(0, item, color)
        end
    end

    return f
end
return main()
