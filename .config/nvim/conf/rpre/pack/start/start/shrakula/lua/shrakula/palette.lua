local function make_greyscale(palette)
    palette["black_dark"] = "#000000"
    palette["black_bright"] = "#352c37"
    palette["white_dark"] = "#897397"
    palette["white_bright"] = "#ede3f7"
end

local function make_color(palette)
    palette["red"] = "#ff5555"
    palette["green"] = "#50fa7b"
    palette["yellow"] = "#f1fa8c"
    palette["purple"] = "#bd93f9"
    palette["magenta"] = "#ff79c6"
    palette["cyan"] = "#8be9fd"

    palette["red_bright"] = "#ff6e6e"
    palette["green_bright"] = "#69ff94"
    palette["yellow_bright"] = "#ffffa5"
    palette["purple_bright"] = "#d6acff"
    palette["magenta_bright"] = "#ff92df"
    palette["cyan_bright"] = "#a4ffff"

    palette["orange"] = "#ffb86c"
end

local function main()
    local palette = {}

    make_greyscale(palette)
    make_color(palette)

    return palette
end
return main()
