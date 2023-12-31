local function setup(palette)
    vim.g.terminal_color_background = "none"
    vim.g.terminal_color_foreground = "none"

    vim.g.terminal_color_0 = palette["black"]
    vim.g.terminal_color_1 = palette["red"]
    vim.g.terminal_color_2 = palette["green"]
    vim.g.terminal_color_3 = palette["yellow"]
    vim.g.terminal_color_4 = palette["blue"]
    vim.g.terminal_color_5 = palette["magenta"]
    vim.g.terminal_color_6 = palette["cyan"]
    vim.g.terminal_color_7 = palette["grey_bright"]

    vim.g.terminal_color_8 = palette["grey_dark"]
    vim.g.terminal_color_9 = palette["red_bright"]
    vim.g.terminal_color_10 = palette["green_bright"]
    vim.g.terminal_color_11 = palette["yellow_bright"]
    vim.g.terminal_color_12 = palette["blue_bright"]
    vim.g.terminal_color_13 = palette["magenta_bright"]
    vim.g.terminal_color_14 = palette["cyan_bright"]
    vim.g.terminal_color_15 = palette["white"]
end

local function main()
    local function f(palette)
        setup(palette)
    end

    return f
end
return main()
