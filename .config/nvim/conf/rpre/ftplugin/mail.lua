local function spell()
    require("cmd")["spell"](true, { "en", "fr", "de" })()
end

local function main()
    spell()
end
main()
