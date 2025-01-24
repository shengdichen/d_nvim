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

local STYLES = {
    GREY_BRIGHT = { fg = PALETTE.grey_bright },

    RED = { fg = PALETTE.red },
    GREEN = { fg = PALETTE.green },
    BLUE = { fg = PALETTE.blue },

    YELLOW = { fg = PALETTE.yellow },
    CYAN = { fg = PALETTE.cyan },
    MAGENTA = { fg = PALETTE.magenta },

    ORANGE = { fg = PALETTE.orange },
    PURPLE = { fg = PALETTE.purple },

    default = { bg = "NONE", fg = PALETTE.white },
    COMMENT = { fg = PALETTE.grey_bright },
    KEYWORD = { fg = PALETTE.magenta },
    SPECIAL = { fg = PALETTE.orange },
    LITERAL = { fg = PALETTE.green },
    TYPE = { fg = PALETTE.cyan },
    FUNCTION = { fg = PALETTE.purple },
    FIELD = { fg = PALETTE.blue },

    _link_default = { link = "Normal" },
    _link_comment = { link = "Comment" },
    _link_literal = { link = "Float" },
    _link_keyword = { link = "Keyword" },
    _link_special = { link = "Special" },
    _link_type = { link = "Type" },
    _link_field = { link = "@field" },
    _link_function = { link = "Function" },
}

---@param groups string[]|string
---@param name string|table<string, string>
STYLES.link_to = function(groups, name)
    if type(groups) == "string" then
        groups = { groups }
    end
    if type(name) == "string" then
        name = { link = name }
    end
    for _, group in ipairs(groups) do
        MAP[group] = name
    end
end

---@param groups string[]|string
STYLES.link_to_default = function(groups)
    STYLES.link_to(groups, STYLES._link_default)
end

---@param groups string[]|string
STYLES.link_to_comment = function(groups)
    STYLES.link_to(groups, STYLES._link_comment)
end

---@param groups string[]|string
STYLES.link_to_literal = function(groups)
    STYLES.link_to(groups, STYLES._link_literal)
end

---@param groups string[]|string
STYLES.link_to_keyword = function(groups)
    STYLES.link_to(groups, STYLES._link_keyword)
end

---@param groups string[]|string
STYLES.link_to_special = function(groups)
    STYLES.link_to(groups, STYLES._link_special)
end

---@param groups string[]|string
STYLES.link_to_type = function(groups)
    STYLES.link_to(groups, STYLES._link_type)
end

---@param groups string[]|string
STYLES.link_to_field = function(groups)
    STYLES.link_to(groups, STYLES._link_field)
end

---@param groups string[]|string
STYLES.link_to_function = function(groups)
    STYLES.link_to(groups, STYLES._link_function)
end

---@return table<string, table<string, any>>
STYLES.make_default = function()
    return { bg = "NONE", fg = PALETTE.white }
end

---@return table<string, table<string, any>>
STYLES.make_comment = function()
    return { fg = PALETTE.grey_bright }
end

---@return table<string, table<string, any>>
STYLES.make_special = function()
    return { fg = PALETTE.orange }
end

---@param style table<string, any>|nil
---@return table<string, any>
STYLES.underline_like = function(style)
    if style == nil then style = {} end
    style.underline = true
    return style
end

---@param style table<string, any>|nil
---@return table<string, any>
STYLES.reverse_like = function(style)
    if style == nil then style = {} end
    style.reverse = true
    return style
end

---@param style table<string, any>|nil
---@return table<string, any>
STYLES.bold_like = function(style)
    if style == nil then style = {} end
    style.bold = true
    return style
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
        MAP.Comment = STYLES.COMMENT
        MAP.MatchParen = STYLES.underline_like({ fg = PALETTE.cyan })
        STYLES.link_to_comment({
            "WinSeparator",
            "EndOfBuffer", -- post-EOF tildes
        })

        MAP.IncSearch = { bg = PALETTE.white, fg = PALETTE.black } -- current match, during search
        STYLES.link_to("CurSearch", "IncSearch")                   -- current match, after search (jumping)
        MAP.Search = { bg = PALETTE.grey_bright, fg = "fg" }       -- other matches

        MAP.Visual = { bg = PALETTE.grey_bright, fg = PALETTE.black }
        MAP.VisualNOS = { bg = PALETTE.grey_dark, fg = "fg" }

        -- notably used for diagnostics, e.g., lsp
        STYLES.link_to_default("NormalFloat")
        STYLES.link_to_comment("FloatBorder")
    end

    local function cursor()
        MAP.Cursor = STYLES.reverse_like()          -- the single point of the cursor
        MAP.CursorLine = { bg = PALETTE.grey_dark } -- the entire line that the cursor is on
        MAP.QuickFixLine = { bg = PALETTE.grey_bright, fg = PALETTE.black }

        STYLES.link_to_default("CursorLineNr")   -- current
        STYLES.link_to_comment("LineNr")         -- non-current

        MAP.CursorColumn = STYLES.reverse_like() -- horizontal indicator for |cursorcolumn|
        MAP.ColorColumn = { bg = PALETTE.grey_dark }
    end

    local function line_horizontal()
        STYLES.link_to_default("StatusLine")   -- current
        STYLES.link_to_comment("StatusLineNC") -- non-current

        STYLES.link_to_comment("Folded")
        STYLES.link_to_comment("FoldColumn")
        STYLES.link_to_comment("TabLine") -- non-current
        STYLES.link_to_default("TabLineFill")
    end

    local function cmd()
        MAP.WarningMsg = STYLES.ORANGE
        MAP.ErrorMsg = STYLES.RED
        MAP.Question = STYLES.PURPLE

        STYLES.link_to_comment("WildMenu")
        MAP.Title = STYLES.CYAN

        MAP.PmenuSel = { bg = PALETTE.white, fg = PALETTE.black } -- selected
        MAP.Pmenu = { bg = PALETTE.grey_dark }                    -- non-selected
        MAP.PmenuSbar = { fg = PALETTE.grey_dark }                -- scrollbar
        STYLES.link_to_comment("PmenuThumb")                      -- none

        MAP.Terminal = { fg = "NONE" }                            -- cursor in builtin terminal
    end

    local function diff()
        MAP.DiffAdd = STYLES.GREEN
        MAP.DiffDelete = STYLES.RED

        -- lines with differences
        MAP.DiffChange = { bg = PALETTE.grey_bright, fg = PALETTE.black }
        -- the differences themselves
        MAP.DiffText = { bg = PALETTE.white, fg = PALETTE.black }
    end

    local function spellcheck()
        MAP.SpellCap = STYLES.YELLOW
        MAP.SpellLocal = STYLES.YELLOW
        MAP.SpellRare = STYLES.ORANGE

        MAP.SpellBad = STYLES.underline_like({ fg = PALETTE.red })
    end

    local function misc()
        -- sign-column(s) for rows without sign(s)
        STYLES.link_to_default("SignColumn")

        MAP.Directory = STYLES.CYAN

        STYLES.link_to_comment("VertSplit")

        STYLES.link_to_comment("SpecialKey")
        STYLES.link_to_comment("NonText")
        STYLES.link_to_comment("Conceal")
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

        MAP.Float = STYLES.LITERAL
        STYLES.link_to_literal({
            "String", "Character", "Number", "Boolean"
        })

        STYLES.link_to_default("Identifier")

        MAP["@field"] = STYLES.FIELD
        STYLES.link_to_field({
            "@property", "@variable.member"
        })

        MAP.Keyword = STYLES.KEYWORD
        STYLES.link_to_keyword({
            "Statement", "Conditional", "Repeat", "Label", "Operator", "Exception",
            "@module.builtin",
            "@attribute", "@attribute.builtin"
        })

        MAP.Function = STYLES.FUNCTION
        STYLES.link_to_function({
            "PreProc", "Define", "Macro", "PreCondit",
            "@function.builtin",

            "Include",
            "@keyword.import", "@include"
        })

        MAP.Type = STYLES.TYPE
        STYLES.link_to_type({
            "StorageClass", "Structure", "TypeDef",
            "@constructor", "@type.builtin"
        })

        MAP.Special = STYLES.SPECIAL
        STYLES.link_to_special({
            "Constant", "SpecialChar", "Tag", "SpecialComment", "Debug"
        })
        map_each(
            { "@string.special.url", "@string.special.path" },
            STYLES.underline_like(STYLES.make_special())
        )

        -- comment; delimiter
        STYLES.link_to_comment(
            {
                "@keyword.luadoc", "@keyword.return.luadoc",
                "@variable.builtin", "@variable.parameter.builtin",
                "Delimiter",
            }
        )
        STYLES.link_to(
            {
                "@punctuation.bracket",
                "@punctuation.special.bash", -- tune down $() and ${} in particular
            },
            "Delimiter"
        )
        MAP["@string.special.url.comment"] = STYLES.underline_like(STYLES.make_comment())

        map_each(
            { "Underlined", "@text.uri" },
            STYLES.underline_like()
        )

        MAP.Ignore = { fg = PALETTE.grey_dark }
        MAP.Error = STYLES.RED

        MAP.Todo = { bg = PALETTE.grey_bright, fg = PALETTE.black }
        STYLES.link_to(
            { "@comment.note", "@comment.todo", "@comment.warning", "@comment.error" },
            "Todo"
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
        STYLES.link_to_default({
            "DiagnosticSignError",
            "DiagnosticSignWarn",
            "DiagnosticSignInfo",
            "DiagnosticSignHint",
            "DiagnosticSignOk"
        })

        map_each(
            {
                "DiagnosticUnderlineTextError",
                "DiagnosticUnderlineTextWarn",
                "DiagnosticUnderlineTextInfo",
                "DiagnosticUnderlineTextHint",
                "DiagnosticUnderlineTextOk"
            },
            STYLES.underline_like()
        )

        STYLES.link_to_comment({
            "DiagnosticVirtualTextError",
            "DiagnosticVirtualTextWarn",
            "DiagnosticVirtualTextInfo",
            "DiagnosticVirtualTextHint",
            "DiagnosticVirtualTextOk"
        })

        STYLES.link_to(
            {
                "DiagnosticFloatingError",
                "DiagnosticFloatingWarn",
                "DiagnosticFloatingInfo",
                "DiagnosticFloatingHint",
                "DiagnosticFloatingOk"
            },
            "NormalFloat"
        )
    end

    local function lsp()
        -- REF:
        --  |:help lsp-semantic-highlight|

        STYLES.link_to("@lsp.type.namespace", "@namespace")
        STYLES.link_to("@lsp.type.interface", "@structure")
        STYLES.link_to("@lsp.type.struct", "@structure")
        STYLES.link_to("@lsp.type.class", "@structure")
        STYLES.link_to("@lsp.type.enum", "@structure")
        STYLES.link_to("@lsp.type.enumMember", "@constant")

        STYLES.link_to("@lsp.type.type", "@type")
        STYLES.link_to("@lsp.type.typeParameter", "@type.definition")

        STYLES.link_to("@lsp.type.function", "@function")
        STYLES.link_to("@lsp.type.method", "@method")
        STYLES.link_to("@lsp.type.decorator", "@method")
        STYLES.link_to("@lsp.type.parameter", "@parameter")

        STYLES.link_to("@lsp.type.variable", "@variable")
        STYLES.link_to("@lsp.type.property", "@property")
        STYLES.link_to("@lsp.type.macro", "@macro")
    end

    local function cmp()
        -- type of complemention, e.g., function, snippet...
        STYLES.link_to_comment("CmpItemKind")
    end

    local function ibl()
        MAP.IblIndent = {
            fg = "#27232b" -- slightly darker than grey-dark
        }
    end

    local function netrw()
        -- REF:
        --  |:help g:netrw_special_syntax|

        STYLES.link_to_comment({
            "netrwTreeBar",  -- e.g., for tree-style (liststyle == 3)
            "netrwClassify", -- e.g., trailing |/| for directories
            "netrwLink",     -- |-->| for sym-link target
        })

        STYLES.link_to_default("netrwDir") -- directory
        MAP.netrwSymLink = STYLES.CYAN     -- sym-link
        MAP.netrwExe = STYLES.GREEN        -- executable
    end

    internal()
    diagnostic()
    lsp()
    cmp()
    ibl()
    netrw()
end

local function filetype()
    local function debug()
        MAP.debugPc = { bg = PALETTE.white, fg = PALETTE.black }
        MAP.debugBreakpoint = { bg = PALETTE.red, fg = "fg" }
    end

    local function gitsigns()
        MAP["@markup.link.gitcommit"] = STYLES.PURPLE

        map_each(
            { "@string.special.path.gitcommit" },
            STYLES.underline_like(STYLES.make_comment())
        )

        -- commit-hash during interactive-rebase (second column)
        STYLES.link_to_comment("@constant.git_rebase")

        STYLES.link_to_comment({
            "GitSignsAdd",
            "GitSignsDelete",
            "GitSignsTopdelete",
            "GitSignsChange",
            "GitSignsChangedelete",
            "GitSignsUntracked",
        })
        map_each(
            {
                "GitSignsStagedAdd",
                "GitSignsStagedDelete",
                "GitSignsStagedTopdelete",
                "GitSignsStagedChange",
                "GitSignsStagedChangedelete"
            },
            STYLES.BLUE
        )
    end

    local function telescope()
        STYLES.link_to_comment({
            "TelescopeBorder", "TelescopeTitle",

            -- prompt
            "TelescopePromptPrefix",
            "TelescopePromptCounter" -- <num>/<num> on RHS
        })

        -- picker
        STYLES.link_to_comment("TelescopeSelectionCaret")   -- caret
        STYLES.link_to("TelescopeSelection", "CursorLine")  -- the current line
        STYLES.link_to("TelescopeMatching", "IncSearch")    -- matching part
        STYLES.link_to("TelescopeMultiSelection", "Visual") -- all selected lines
        STYLES.link_to_comment({
            "TelescopeResultsSpecialComment",               -- e.g., line-number when searching current buffer
            "TelescopeResultsNumber",                       -- e.g., buffer id
            "TelescopeResultsComment",                      -- e.g., buffer type (%a, #h...)
        })

        -- preview
        STYLES.link_to("TelescopePreviewLine", "Visual")     -- the current line
        STYLES.link_to("TelescopePreviewMatch", "IncSearch") -- matching part
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
