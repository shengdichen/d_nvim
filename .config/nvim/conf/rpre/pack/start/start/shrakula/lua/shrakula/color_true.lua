local PALETTE = require("shrakula.palette")

---@type table<string, table<string, any>>
local MAP = {}

---@param groups string[]
---@param style table<string, any>
local function map_each(groups, style)
    for _, group in ipairs(groups) do
        MAP[group] = style
    end
end

local function common()
    -- REF:
    --  :h guifg
    -- NOTE:
    --  a.  passthrough, i.e., use deduction from syntax/treesitter
    --  ->  do NOT specify OR "NONE"
    --  b.  any fixed color (e.g., if we want to ignore hl-deduction)
    --  ->  specify explicitly (if same as |Normal|, consider using "fg")

    local function general()
        MAP.Comment = { fg = PALETTE.grey_bright }
        MAP.MatchParen = { fg = PALETTE.cyan, underline = true }
        MAP.EndOfBuffer = { fg = PALETTE.black }                   -- tilde at EOF

        MAP.IncSearch = { bg = PALETTE.white, fg = PALETTE.black } -- current match, during search
        MAP.CurSearch = { link = "IncSearch" }                     -- current match, after search (jumping)
        MAP.Search = { bg = PALETTE.grey_bright, fg = "fg" }       -- other matches

        MAP.Visual = { bg = PALETTE.grey_bright, fg = PALETTE.black }
        MAP.VisualNOS = { bg = PALETTE.grey_dark, fg = "fg" }

        -- notably used for diagnostics, e.g., lsp
        MAP.NormalFloat = { link = "Normal" }
        MAP.FloatBorder = { link = "Comment" }
    end

    local function cursor()
        MAP.Cursor = { reverse = true }             -- the single point of the cursor
        MAP.CursorLine = { bg = PALETTE.grey_dark } -- the entire line that the cursor is on
        MAP.QuickFixLine = { bg = PALETTE.grey_bright, fg = PALETTE.black }

        MAP.CursorLineNr = { link = "Normal" } -- current
        MAP.LineNr = { link = "Comment" }      -- non-current

        MAP.CursorColumn = { reverse = true }  -- horizontal indicator for |cursorcolumn|
        MAP.ColorColumn = { bg = PALETTE.grey_dark }
    end

    local function line_horizontal()
        MAP.StatusLine = { link = "Normal" }    -- current
        MAP.StatusLineNC = { link = "Comment" } -- non-current

        MAP.Folded = { link = "Comment" }
        MAP.FoldColumn = { link = "Comment" }
        MAP.TabLine = { link = "Comment" } -- non-current
        MAP.TabLineFill = { link = "Normal" }
    end

    local function cmd()
        MAP.WarningMsg = { fg = PALETTE.orange }
        MAP.ErrorMsg = { fg = PALETTE.red }
        MAP.Question = { fg = PALETTE.purple }

        MAP.WildMenu = { link = "Comment" }
        MAP.Title = { fg = PALETTE.cyan }

        MAP.PmenuSel = { bg = PALETTE.white, fg = PALETTE.black } -- selected
        MAP.Pmenu = { bg = PALETTE.grey_dark }                    -- non-selected
        MAP.PmenuSbar = { fg = PALETTE.grey_dark }                -- scrollbar
        MAP.PmenuThumb = { link = "Comment" }                     -- none

        MAP.Terminal = { fg = "NONE" }                            -- cursor in builtin terminal
    end

    local function diff()
        MAP.DiffAdd = { fg = PALETTE.green }
        MAP.DiffDelete = { fg = PALETTE.red }

        -- lines with differences
        MAP.DiffChange = { bg = PALETTE.grey_bright, fg = PALETTE.black }
        -- the differences themselves
        MAP.DiffText = { bg = PALETTE.white, fg = PALETTE.black }
    end

    local function spellcheck()
        MAP.SpellCap = { fg = PALETTE.yellow }
        MAP.SpellLocal = { fg = PALETTE.yellow }
        MAP.SpellRare = { fg = PALETTE.orange }

        MAP.SpellBad = { fg = PALETTE.red, underline = true }
    end

    local function misc()
        -- sign-column(s) for rows without sign(s)
        MAP.SignColumn = { link = "Normal" }

        MAP.Directory = { fg = PALETTE.cyan }

        MAP.VertSplit = { link = "Comment" }

        MAP.SpecialKey = { link = "Comment" }
        MAP.NonText = { link = "Comment" }
        MAP.Conceal = { link = "Comment" }
    end

    general()
    cursor()
    line_horizontal()
    cmd()
    diff()
    spellcheck()
    misc()
end

local function syntax()
    local function internal()
        -- REF:
        --  |:help group-name|
        --  |:help treesitter-highlight-groups|

        -- literals
        map_each(
            { "String", "Character", "Number", "Boolean", "Float" },
            { fg = PALETTE.green }
        )

        MAP.Identifier = { link = "Normal" }
        map_each(
            { "@field", "@property", "@variable.member" },
            { fg = PALETTE.blue }
        )

        -- keyword
        map_each(
            { "Statement", "Conditional", "Repeat", "Label", "Operator", "Keyword", "Exception" },
            { fg = PALETTE.magenta }
        )
        MAP["@module.builtin"] = { link = "Label" }

        -- function
        map_each(
            { "Function", "PreProc", "Include", "Define", "Macro", "PreCondit" },
            { fg = PALETTE.purple }
        )
        MAP["@function.builtin"] = { link = "Function" }
        map_each(
            { "@keyword.import", "@include" },
            { link = "Include" }
        )

        -- type
        map_each(
            { "Type", "StorageClass", "Structure", "TypeDef" },
            { fg = PALETTE.cyan }
        )
        map_each(
            { "@constructor", "@type.builtin" },
            { link = "Type" }
        )

        -- global; special
        map_each(
            { "Constant", "Special", "SpecialChar", "Tag", "SpecialComment", "Debug" },
            { fg = PALETTE.orange }
        )

        -- comment; delimiter
        map_each(
            {
                "Delimiter",
                "@keyword.luadoc", "@keyword.return.luadoc",
                "@variable.builtin", "@variable.parameter.builtin",
            },
            { link = "Comment" }
        )
        map_each(
            {
                "@punctuation.bracket",
                "@punctuation.special.bash", -- tune down $() and ${} in particular
            },
            { link = "Delimiter" }
        )

        MAP.Underlined = { fg = "fg", underline = true }
        MAP["@text.uri"] = { underline = true }
        MAP["@string.special.url"] = { link = "@text.uri" }

        MAP.Ignore = { fg = PALETTE.grey_dark }
        MAP.Error = { fg = PALETTE.red }

        MAP.Todo = { bg = PALETTE.grey_bright, fg = PALETTE.black }
        map_each(
            { "@comment.note", "@comment.todo", "@comment.warning", "@comment.error" },
            { link = "Todo" }
        )
    end

    local function diagnostic()
        -- REF
        --  |:help diagnostic-highlights|

        local bg = "#433f4b" -- slightly brighter than grey-dark
        MAP.DiagnosticError = { bg = bg, fg = PALETTE.red }
        MAP.DiagnosticWarn = { bg = bg, fg = PALETTE.yellow }
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
                "DiagnosticUnderlineTextError",
                "DiagnosticUnderlineTextWarn",
                "DiagnosticUnderlineTextInfo",
                "DiagnosticUnderlineTextHint",
                "DiagnosticUnderlineTextOk"
            },
            { underline = true }
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

    local function lsp()
        -- REF:
        --  |:help lsp-semantic-highlight|

        MAP["@lsp.type.namespace"] = { link = "@namespace" }
        MAP["@lsp.type.interface"] = { link = "@structure" }
        MAP["@lsp.type.struct"] = { link = "@structure" }
        MAP["@lsp.type.class"] = { link = "@structure" }
        MAP["@lsp.type.enum"] = { link = "@structure" }
        MAP["@lsp.type.enumMember"] = { link = "@constant" }

        MAP["@lsp.type.type"] = { link = "@type" }
        MAP["@lsp.type.typeParameter"] = { link = "@type.definition" }

        MAP["@lsp.type.function"] = { link = "@function" }
        MAP["@lsp.type.method"] = { link = "@method" }
        MAP["@lsp.type.decorator"] = { link = "@method" }
        MAP["@lsp.type.parameter"] = { link = "@parameter" }

        MAP["@lsp.type.variable"] = { link = "@variable" }
        MAP["@lsp.type.property"] = { link = "@property" }
        MAP["@lsp.type.macro"] = { link = "@macro" }
    end

    local function cmp()
        -- type of complemention, e.g., function, snippet...
        MAP.CmpItemKind = { link = "Comment" }
    end

    local function ibl()
        MAP.IblIndent = {
            fg = "#27232b" -- slightly darker than grey-dark
        }
    end

    internal()
    diagnostic()
    lsp()
    cmp()
    ibl()
end

local function filetype()
    local function debug()
        MAP.debugPc = { bg = PALETTE.white, fg = PALETTE.black }
        MAP.debugBreakpoint = { bg = PALETTE.red, fg = "fg" }
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
        MAP.TelescopeBorder = { link = "Comment" }
        MAP.TelescopeTitle = { link = "Comment" }

        -- prompt
        MAP.TelescopePromptPrefix = { link = "Comment" }
        MAP.TelescopePromptCounter = { link = "Comment" } -- <num>/<num> on RHS

        -- picker
        MAP.TelescopeSelectionCaret = { link = "Comment" } -- caret
        MAP.TelescopeSelection = { link = "CursorLine" }   -- the current line
        MAP.TelescopeMatching = { link = "IncSearch" }     -- matching part
        MAP.TelescopeMultiSelection = { link = "Visual" }  -- all selected lines
        map_each(
            {
                "TelescopeResultsSpecialComment", -- e.g., line-number when searching current buffer
                "TelescopeResultsNumber",         -- e.g., buffer id
                "TelescopeResultsComment",        -- e.g., buffer type (%a, #h...)
            },
            { link = "Comment" }
        )

        -- preview
        MAP.TelescopePreviewLine = { link = "Visual" }     -- the current line
        MAP.TelescopePreviewMatch = { link = "IncSearch" } -- matching part
    end

    debug()
    gitsigns()
    telescope()
end

local function main()
    -- define "Normal" first to allow shortcuts "fg"&"bg"
    vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", fg = PALETTE.white })

    common()
    syntax()
    filetype()

    for group, style in pairs(MAP) do
        vim.api.nvim_set_hl(0, group, style)
    end
end
return main
