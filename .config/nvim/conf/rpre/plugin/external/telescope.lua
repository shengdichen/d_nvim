local function conf()
    local c = {}

    c.defaults = {
        -- REF:
        --  https://en.wikipedia.org/wiki/Box-drawing_character
        borderchars = { " ", "│", " ", "│", "┌", "┐", "┘", "└" },

        results_title = false,
        prompt_title = false,

        selection_caret = "", -- the current line in picker
        multi_icon = "",      -- all selected lines in picker
        entry_prefix = "",    -- all other lines in picker
    }

    require("telescope").setup(c)
end

local function live_grep(opts)
    -- disable title by default
    local c = require("util").update({ prompt_title = false }, opts)
    return function()
        require("telescope.builtin").live_grep(c)
    end
end

local function bind()
    local builtin = require("telescope.builtin")

    local function content()
        -- current buffer
        vim.keymap.set("n", "f/", builtin.current_buffer_fuzzy_find)
        -- all open buffers
        vim.keymap.set(
            "n",
            "ff",
            live_grep({ search_dirs = require("internal").buffers_open() })
        )
        -- all under cwd
        vim.keymap.set(
            "n",
            "fd",
            live_grep({})
        )
    end

    local function misc()
        vim.keymap.set("n", "fb", builtin.buffers)

        vim.keymap.set(
            "n",
            "fg",
            function()
                builtin.find_files({ hidden = true, follow = true })
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
