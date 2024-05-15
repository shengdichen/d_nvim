local PALETTE = {}

local function make_greyscale()
    PALETTE["black"] = "#000000"
    PALETTE["grey_dark"] = "#2b272f"
    PALETTE["grey_bright"] = "#97879f"
    PALETTE["white"] = "#efe3fb"
end

local function make_color_normal()
    -- primary
    PALETTE["red"] = "#ef1757"
    PALETTE["green"] = "#3fbf4f"
    PALETTE["blue"] = "#1f97df"

    -- secondary
    PALETTE["yellow"] = "#efd767"
    PALETTE["cyan"] = "#7fd7f3"
    PALETTE["magenta"] = "#ef77c7"

    -- tertiary
    PALETTE["orange"] = "#efa74f"
    PALETTE["purple"] = "#a787f7"
end

local function make_color_bright()
    PALETTE["red_bright"] = "#ff2f2f"
    PALETTE["green_bright"] = "#2fff2f"
    PALETTE["yellow_bright"] = "#ffff2f"
    PALETTE["blue_bright"] = "#2f2fff"
    PALETTE["magenta_bright"] = "#ff2fff"
    PALETTE["cyan_bright"] = "#2fffff"
end

local function main()
    make_greyscale()
    make_color_normal()
    make_color_bright()

    return PALETTE
end
return main()
