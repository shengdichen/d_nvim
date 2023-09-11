local function make_greyscale(palette)
    palette["black"] = "#000000"
    palette["black_bright"] = "#2b272f"
    palette["white_dark"] = "#97879f"
    palette["white"] = "#efe3fb"
end

local function make_color_normal(palette)
    -- primary
    palette["red"] = "#ef1757"
    palette["green"] = "#3fbf4f"
    palette["blue"] = "3f1ff7"

    -- secondary
    palette["yellow"] = "#efd767"
    palette["cyan"] = "#77eff7"
    palette["magenta"] = "#ef77c7"

    -- tertiary
    palette["orange"] = "#efa74f"
    palette["purple"] = "#a787f7"
end

local function make_color_bright(palette)
    palette["red_bright"] = "#ff6e6e"
    palette["green_bright"] = "#69ff94"
    palette["yellow_bright"] = "#ffffa5"
    palette["blue_bright"] = "#d6acff"
    palette["magenta_bright"] = "#ff92df"
    palette["cyan_bright"] = "#a4ffff"
end

local function main()
    local palette = {}

    make_greyscale(palette)
    make_color_normal(palette)
    make_color_bright(palette)

    return palette
end
return main()
