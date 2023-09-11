local function make_greyscale(palette)
    palette["bg"] = "None"
    palette["fg"] = "None"

    palette["white"] = "#abb2bf"
    palette["black"] = "#191a21"

    palette["black_dark"] = "#000000"
    palette["black_bright"] = "#352c37"
    palette["white_dark"] = "#897397"
    palette["white_bright"] = "#ede3f7"

    palette["selection"] = "#44475a"
    palette["comment"] = "#6272a4"

    palette["menu"] = "#21222C"
    palette["visual"] = "#3e4452"
    palette["gutter_fg"] = "#4b5263"
    palette["nontext"] = "#3b4048"
end

local function make_color(palette)
    palette["red"] = "#ff5555"
    palette["orange"] = "#ffb86c"
    palette["yellow"] = "#F1FA8C"
    palette["green"] = "#50fa7b"
    palette["purple"] = "#bd93f9"
    palette["cyan"] = "#8be9fd"
    palette["pink"] = "#ff79c6"

    palette["bright_red"] = "#ff6e6e"
    palette["bright_green"] = "#69ff94"
    palette["bright_yellow"] = "#ffffa5"
    palette["bright_blue"] = "#d6acff"
    palette["bright_magenta"] = "#ff92df"
    palette["bright_cyan"] = "#a4ffff"
    palette["bright_white"] = "#ffffff"
end

local function main()
    local palette = {}

    make_greyscale(palette)
    make_color(palette)

    return palette
end
return main()
