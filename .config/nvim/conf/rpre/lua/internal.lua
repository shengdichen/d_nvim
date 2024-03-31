local MODULE = {}

MODULE.unbind = function(mode, lhs, args)
    vim.keymap.set(mode, lhs, "", args)
end

MODULE.run_in_terminal = function(cmd)
    vim.cmd("terminal $SHELL -c " .. '"' .. cmd .. '"')
end

MODULE.spell = function(enable, langs)
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
            langs = "en"
        end
        vim.opt_local.spelllang = langs
    end
end

MODULE.statusline = function(level)
    vim.opt_local.laststatus = level
end

return MODULE
