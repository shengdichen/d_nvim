local function colorscheme()
    -- use RGB color if available
    vim.opt.termguicolors = true

    vim.cmd("colorscheme shrakula")
end

local function signcolumn()
    -- REF:
    --  https://github.com/neovim/neovim/issues/990

    -- set to |number| if sign(s) shall take over line-number
    vim.opt.signcolumn = "auto:3"
end

local function ibl()
    require("ibl").setup(
        {
            indent = { char = "┆" },
            scope = { enabled = false },
            viewport_buffer = { min = 10, max = 50 }
        }
    )
end

local function general()
    vim.opt.number = true         -- show line-number...
    vim.opt.relativenumber = true -- ...relative to current

    -- width of "gutter" column:
    --  1. 3 digits for line-number (will increase if insufficient)
    --  2. right-most character always left blank
    vim.opt.numberwidth = 4

    -- number of top-/bottom-most lines kept visible when scrolling
    vim.opt.scrolloff = 2

    vim.opt.visualbell = true
end

local function cursor()
    local styles = {
        "n:block-Cursor",    -- normal
        "i-c:ver100-Cursor", -- insert & commandline
        "v-o:hor100-Cursor"  -- visual & operator-pending
    }
    vim.opt.guicursor = table.concat(styles, ",")

    -- highlight the line that the cursor is currently on
    vim.opt.cursorline = true

    local function restore_cursor()
        -- steady, beam-shaped
        vim.opt.guicursor = "a:ver100-blinkon0"
    end
    vim.api.nvim_create_autocmd({ "VimLeave" }, {
        pattern = { "*" },
        callback = restore_cursor,
    })
end

local function filler()
    local item_to_char = {}
    item_to_char.horiz = "-"
    item_to_char.vert = "|"

    item_to_char.fold = "-"

    item_to_char.eob = " " -- illusion of hidden post-EOF tildes

    vim.opt.fillchars = item_to_char
end

local function main()
    colorscheme()
    signcolumn()
    ibl()
    general()
    cursor()
    filler()
end
main()
