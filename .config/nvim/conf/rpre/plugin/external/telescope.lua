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

local function live_grep(opts)
    local c = {
        prompt_title = false,
        preview_title = false, -- hide "Grep Preview" (undocumented)
    }

    return function()
        telescope_builtin.live_grep(util_lua.update(c, opts))
    end
end

local function bind()
    local function content()
        -- current buffer
        vim.keymap.set("n", "f/", telescope_builtin.current_buffer_fuzzy_find)
        -- all open buffers
        vim.keymap.set(
            "n",
            "ff",
            live_grep({ search_dirs = util_vim.buffers_open() })
        )
        -- all under cwd
        vim.keymap.set("n", "fd", live_grep({}))
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
