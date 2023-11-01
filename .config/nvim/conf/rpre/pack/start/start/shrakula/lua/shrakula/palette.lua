local function make_greyscale(palette)
    palette["black"] = "#000000"
    palette["grey_dark"] = "#2b272f"
    palette["grey_bright"] = "#97879f"
    palette["white"] = "#efe3fb"
end

local function make_color_normal(palette)
    -- primary
    palette["red"] = "#ef1757"
    palette["green"] = "#3fbf4f"
    palette["blue"] = "#1f97df"

    -- secondary
    palette["yellow"] = "#efd767"
    palette["cyan"] = "#7fd7f3"
    palette["magenta"] = "#ef77c7"

    -- tertiary
    palette["orange"] = "#efa74f"
    palette["purple"] = "#a787f7"
end

local function make_color_bright(palette)
    palette["red_bright"] = "#ff2f2f"
    palette["green_bright"] = "#2fff2f"
    palette["yellow_bright"] = "#ffff2f"
    palette["blue_bright"] = "#2f2fff"
    palette["magenta_bright"] = "#ff2fff"
    palette["cyan_bright"] = "#2fffff"
end

local function main()
    local palette = {}

    make_greyscale(palette)
    make_color_normal(palette)
    make_color_bright(palette)

    return palette
end
return main()
