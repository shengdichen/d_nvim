local function spell()
    require("internal")["spell"](true, { "en", "fr", "de" })()
end

local function main()
    spell()
end
main()
