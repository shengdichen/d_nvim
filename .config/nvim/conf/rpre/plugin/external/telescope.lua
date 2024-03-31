local function bind()
    local builtin = require("telescope.builtin")

    local function content()
        -- current buffer
        vim.keymap.set("n", "f/", builtin.current_buffer_fuzzy_find)
        -- all open buffers
        vim.keymap.set(
            "n",
            "ff",
            function()
                builtin.live_grep({ search_dirs = require("internal").buffers_open() })
            end
        )
        -- all under cwd
        vim.keymap.set(
            "n",
            "fd", function()
                builtin.live_grep()
            end
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
    bind()
end
main()
