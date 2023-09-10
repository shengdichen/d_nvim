local function make_greyscale(palette)
    palette["bg"] = "None"
    palette["fg"] = "None"

    palette["white"] = "#ABB2BF"
    palette["black"] = "#191A21"

    palette["black_dark"] = "#000000"
    palette["black_bright"] = "#352c37"
    palette["white_dark"] = "#897397"
    palette["white_bright"] = "#ede3f7"

    palette["selection"] = "#44475A"
    palette["comment"] = "#6272A4"

    palette["menu"] = "#21222C"
    palette["visual"] = "#3E4452"
    palette["gutter_fg"] = "#4B5263"
    palette["nontext"] = "#3B4048"
end

local function make_color(palette)
    palette["red"] = "#FF5555"
    palette["orange"] = "#FFB86C"
    palette["yellow"] = "#F1FA8C"
    palette["green"] = "#50fa7b"
    palette["purple"] = "#BD93F9"
    palette["cyan"] = "#8BE9FD"
    palette["pink"] = "#FF79C6"

    palette["bright_red"] = "#FF6E6E"
    palette["bright_green"] = "#69FF94"
    palette["bright_yellow"] = "#FFFFA5"
    palette["bright_blue"] = "#D6ACFF"
    palette["bright_magenta"] = "#FF92DF"
    palette["bright_cyan"] = "#A4FFFF"
    palette["bright_white"] = "#FFFFFF"
end

local function main()
    local palette = {}

    make_greyscale(palette)
    make_color(palette)

    return palette
end
return main()
