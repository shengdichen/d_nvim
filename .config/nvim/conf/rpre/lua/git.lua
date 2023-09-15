local function show_log()
    return "git log --all --patch --graph"
end

local function show_cache_smart()
    -- show currently staged if existent, otherwise inspect HEAD
    return "if " ..
        "git diff --cached --quiet" ..
        "; then " ..
        "git show @" ..
        "; else " ..
        "git diff --cached" ..
        "; fi"
end

local function main()
    local d = {}
    d["show_log"] = show_log
    d["show_cache_smart"] = show_cache_smart

    return d
end
return main()
