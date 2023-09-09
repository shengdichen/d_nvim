local function make_greyscale(palette)
    palette["bg"] = "None"
    palette["fg"] = "None"

    palette["selection"] = "#44475A"
    palette["comment"] = "#6272A4"

    palette["menu"] = "#21222C"
    palette["visual"] = "#3E4452"
    palette["gutter_fg"] = "#4B5263"
    palette["nontext"] = "#3B4048"
    palette["white"] = "#ABB2BF"
    palette["black"] = "#191A21"
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
