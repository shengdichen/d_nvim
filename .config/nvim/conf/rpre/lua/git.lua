local function show_log()
    return "git log --all --patch --graph"
end

local function show(commit)
    if not commit then
        commit = "@"
    end
    return "git show " .. commit
end

local function show_staged()
    return "git diff --cached"
end

local function show_cache_smart()
    -- show currently staged if existent, otherwise inspect HEAD
    return "if " ..
        "git diff --cached --quiet" ..
        "; then " ..
        show("") ..
        "; else " ..
        show_staged() ..
        "; fi"
end

local function main()
    local d = {}
    d["show_log"] = show_log
    d["show"] = show
    d["show_staged"] = show_staged
    d["show_cache_smart"] = show_cache_smart

    return d
end
return main()
