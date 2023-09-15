local run_in_terminal = require("cmd")["run_in_terminal"]

local augroup = "GitLayout"

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

local function layout_triple()
    vim.cmd("rightbelow vsplit")

    -- lower-right
    vim.cmd("rightbelow split")
    run_in_terminal(show_log())

    -- upper-right
    vim.cmd("wincmd k")
    run_in_terminal(show_cache_smart())

    -- left
    vim.cmd("wincmd h")
    vim.cmd("startinsert")
end

local function layout_double(start_insert)
    return function()
        -- right
        vim.cmd("rightbelow vsplit")
        run_in_terminal(show_log())

        -- left
        vim.cmd("wincmd h")
        if start_insert then
            vim.cmd("startinsert")
        end
    end
end

local function main()
    local d = {}

    d["augroup"] = augroup

    d["show_log"] = show_log
    d["show"] = show
    d["show_staged"] = show_staged
    d["show_cache_smart"] = show_cache_smart

    d["layout_triple"] = layout_triple
    d["layout_double"] = layout_double

    return d
end
return main()
