local function handling()
    -- sync [n]vim's (internal) dir with current dir of netrw
    vim.g.netrw_keepdir = 1

    -- use dir-cache only on remotes
    vim.g.netrw_fastbrowse = 1

    -- preview in vsplit
    vim.g.netrw_preview = 1

    -- open files in current window (and consume it!) with <CR>
    vim.g.netrw_browse_split = 0
end

local function visual()
    vim.g.netrw_banner = 0 -- hide banner

    vim.g.netrw_hide = 0
    vim.g.netrw_liststyle = 1 -- show extra info

    vim.g.netrw_sort_options = "name"
    vim.g.netrw_sort_direction = "normal" -- in ascending order
end

local function bind()
    -- NOTE:
    --  :split =: netrw-o
    --  :vsplit =: netrw-v
    --  :tabnew =: netrw-t
    --  preview =: netrw-p

    vim.keymap.set("c", ":E", "vsplit +Explore")
    vim.keymap.set("c", ":e", "tabnew +Explore")
end

local function main()
    handling()
    visual()
    bind()
end
main()
