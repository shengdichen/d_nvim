local util_lua = require("util")
local util_vim = require("internal")

local telescope = require("telescope")
local telescope_builtin = require("telescope.builtin")

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
    }

    telescope.setup(c)

    local extensions = { "fzf" }
    for _, ext in ipairs(extensions) do
        telescope.load_extension(ext)
    end
end

local function bind()
    local config_quiet = {
        prompt_title = false,
        preview_title = false, -- hide "Grep Preview" (undocumented)
    }

    local function content()
        -- current buffer
        vim.keymap.set("n", "f/", function()
            telescope_builtin.current_buffer_fuzzy_find(config_quiet)
        end)
        -- all open buffers
        vim.keymap.set("n", "ff", function()
            telescope_builtin.live_grep(util_lua.combine({
                config_quiet, { search_dirs = util_vim.buffers_open() }
            }))
        end)
        -- all under cwd
        vim.keymap.set("n", "fd", function()
            telescope_builtin.live_grep(config_quiet)
        end)
    end

    local function misc()
        vim.keymap.set("n", "fb", telescope_builtin.buffers)

        vim.keymap.set(
            "n",
            "fg",
            function()
                telescope_builtin.find_files({ hidden = true, follow = true })
            end
        )
    end

    content()
    misc()
end

local function main()
    conf()
    bind()
end
main()
