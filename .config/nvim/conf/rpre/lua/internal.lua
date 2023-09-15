local function unbind(mode, lhs, args)
    vim.keymap.set(mode, lhs, "", args)
end

local function run_in_terminal(cmd)
    vim.cmd("terminal $SHELL -c " .. '"' .. cmd .. '"')
end

local function spell(enable, langs)
    return function()
        if enable then
            vim.opt_local.spell = true
        else
            vim.opt_local.spell = false
        end

        if type(langs) == "table" then
            langs = table.concat(langs, ",")
        end
        if not langs then
            t = "en"
        end
        vim.opt_local.spelllang = langs
    end
end

local function statusline(level)
    vim.opt_local.laststatus = level
end

local function main()
    local d = {}

    d["unbind"] = unbind
    d["run_in_terminal"] = run_in_terminal
    d["spell"] = spell
    d["statusline"] = statusline

    return d
end
return main()
