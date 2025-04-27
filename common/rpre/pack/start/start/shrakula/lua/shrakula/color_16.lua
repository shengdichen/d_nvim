local PALETTE = require("shrakula.palette")

local function setup()
    vim.g.terminal_color_background = "none"
    vim.g.terminal_color_foreground = "none"

    vim.g.terminal_color_0 = PALETTE["black"]
    vim.g.terminal_color_1 = PALETTE["red"]
    vim.g.terminal_color_2 = PALETTE["green"]
    vim.g.terminal_color_3 = PALETTE["yellow"]
    vim.g.terminal_color_4 = PALETTE["blue"]
    vim.g.terminal_color_5 = PALETTE["magenta"]
    vim.g.terminal_color_6 = PALETTE["cyan"]
    vim.g.terminal_color_7 = PALETTE["grey_bright"]

    vim.g.terminal_color_8 = PALETTE["grey_dark"]
    vim.g.terminal_color_9 = PALETTE["red_bright"]
    vim.g.terminal_color_10 = PALETTE["green_bright"]
    vim.g.terminal_color_11 = PALETTE["yellow_bright"]
    vim.g.terminal_color_12 = PALETTE["blue_bright"]
    vim.g.terminal_color_13 = PALETTE["magenta_bright"]
    vim.g.terminal_color_14 = PALETTE["cyan_bright"]
    vim.g.terminal_color_15 = PALETTE["white"]
end

local function main()
    setup()
end
return main
