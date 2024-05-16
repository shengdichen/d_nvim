local util_vim = require("util_vim")

local augroup = "GitLayout"

local function show_log(show_patch)
    return function()
        if show_patch then
            return "git lg"
        else
            return "git alo"
        end
    end
end

local function show(commit)
    if not commit then
        commit = "@"
    end
    return "git so " .. commit
end

local function show_staged()
    return "git dc"
end

local function show_cache_smart()
    -- show currently staged if existent, otherwise inspect HEAD
    return "if " ..
        show_staged() .. " --quiet" ..
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
    util_vim.run_in_terminal(show_log(false)())

    -- upper-right
    vim.cmd("wincmd k")
    util_vim.run_in_terminal(show_cache_smart())

    -- left
    vim.cmd("wincmd h")
    vim.cmd("startinsert")
end

local function layout_double(start_insert, show_patch)
    return function()
        -- right
        vim.cmd("rightbelow vsplit")
        util_vim.run_in_terminal(show_log(show_patch)())

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
