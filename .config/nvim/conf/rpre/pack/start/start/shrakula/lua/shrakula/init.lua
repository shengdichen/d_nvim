local function check_version()
    if vim.version().minor < 7 then
        vim.notify_once("Update neovim to >= v0.7")
        return false
    end
    return true
end

local function setup_vim()
    if vim.g.colors_name then
        vim.cmd("highlight clear")
    end

    if vim.fn.exists("syntax_on") then
        vim.cmd("syntax reset")
    end

    vim.o.background = "dark"
    vim.o.termguicolors = true
    vim.g.colors_name = "shrakula"
end

local function set_color_true(palette)
    local normal, mapping = require("shrakula.mapping")(palette)

    -- define "Normal" first to allow shortcuts "fg"&"bg"
    vim.api.nvim_set_hl(0, "Normal", normal)
    for item, color in pairs(mapping) do
        vim.api.nvim_set_hl(0, item, color)
    end
end

local function set_color_256(palette)
    vim.g.terminal_color_0 = palette.black
    vim.g.terminal_color_1 = palette.red
    vim.g.terminal_color_2 = palette.green
    vim.g.terminal_color_3 = palette.yellow
    vim.g.terminal_color_4 = palette.purple
    vim.g.terminal_color_5 = palette.pink
    vim.g.terminal_color_6 = palette.cyan
    vim.g.terminal_color_7 = palette.white
    vim.g.terminal_color_8 = palette.selection
    vim.g.terminal_color_9 = palette.bright_red
    vim.g.terminal_color_10 = palette.bright_green
    vim.g.terminal_color_11 = palette.bright_yellow
    vim.g.terminal_color_12 = palette.bright_blue
    vim.g.terminal_color_13 = palette.bright_magenta
    vim.g.terminal_color_14 = palette.bright_cyan
    vim.g.terminal_color_15 = palette.bright_white

    vim.g.terminal_color_background = palette.bg
    vim.g.terminal_color_foreground = palette.fg
end

local function main()
    if not check_version() then return end
    setup_vim()

    local palette = require("shrakula.palette")
    set_color_true(palette)
    set_color_256(palette)
end
return main
