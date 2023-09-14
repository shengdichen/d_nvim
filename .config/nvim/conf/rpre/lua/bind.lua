local function unbind(mode, lhs, args)
    vim.keymap.set(mode, lhs, "", args)
end

local function main()
    local d = {}
    d["unbind"] = unbind

    return d
end
return main()
