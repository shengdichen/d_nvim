local util_lua = require("util")
local util_vim = require("internal")

local telescope = require("telescope")
local telescope_builtin = require("telescope.builtin")
local telescope_actions = require("telescope.actions")

local function conf()
    local c = {}

    c.defaults = {
        -- REF:
        --  https://en.wikipedia.org/wiki/Box-drawing_character
        borderchars = { " ", "│", " ", "│", "┌", "┐", "┘", "└" },

        -- NOTE:
        --  setting (global) prompt_title & preview_title here has no effect
        results_title = false,

        selection_caret = "",           -- the current line in picker
        multi_icon = "",                -- all selected lines in picker
        entry_prefix = "",              -- all other lines in picker

        layout_strategy = "horizontal", -- default layout
        layout_config = {
            prompt_position = "top",    -- prompt above picker
            height = 0.89,
            width = 0.89,

            horizontal = {
                preview_width = 0.59 -- proportion of preview (RHS)
            }
        },
        sorting_strategy = "ascending", -- simulate fzf's --reverse
        mappings = {
            i = {
                ["<C-q>"] = telescope_actions.smart_send_to_qflist
            }
        },
    }

    local function pickers()
        c.pickers = {}
        local config_no_preview = { preview_title = false }
        for _, picker in ipairs({
            "buffers",
            "find_files",
            "quickfix",
            "lsp_references",
        }) do
            c.pickers[picker] = config_no_preview
        end

        local config_no_preview_no_prompt = {
            preview_title = false, -- hide "Grep Preview" (undocumented)
            prompt_title = false,
        }
        for _, picker in ipairs({
            "current_buffer_fuzzy_find",
            "live_grep",
        }) do
            c.pickers[picker] = config_no_preview_no_prompt
        end
    end

    pickers()
    telescope.setup(c)

    local extensions = { "fzf" }
    for _, ext in ipairs(extensions) do
        telescope.load_extension(ext)
    end
end

local function bind()
    vim.keymap.set("c", ":F", "Telescope ")

    local config_quiet = {
        prompt_title = false,
        preview_title = false, -- hide "Grep Preview" (undocumented)
    }

    local function content()
        -- current buffer
        vim.keymap.set("n", "f/", telescope_builtin.current_buffer_fuzzy_find)
        -- all open buffers
        vim.keymap.set("n", "ff", function()
            telescope_builtin.live_grep({ search_dirs = util_vim.buffers_open() })
        end)
        -- all under cwd
        vim.keymap.set("n", "fd", telescope_builtin.live_grep)
    end

    local function misc()
        vim.keymap.set("n", "fb", telescope_builtin.buffers)

        vim.keymap.set("n", "fg", function()
            telescope_builtin.find_files({
                hidden = true, follow = true
            })
        end)

        vim.keymap.set("n", "<Leader>q", telescope_builtin.quickfix)
        vim.keymap.set("n", "<Leader>Q", telescope_builtin.quickfixhistory)
    end

    content()
    misc()
end

local function main()
    conf()
    bind()
end
main()
