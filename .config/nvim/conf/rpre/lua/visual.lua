local function statusline(level)
    vim.opt_local.laststatus = level
end

local function main()
    local d = {}
    d["statusline"] = statusline

    return d
end
return main()
