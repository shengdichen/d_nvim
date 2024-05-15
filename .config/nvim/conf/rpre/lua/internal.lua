local util = require("util")

local MODULE = {}

---@param mode string|table
---@param lhs string
---@param args table|nil
MODULE.unbind = function(mode, lhs, args)
    vim.keymap.set(mode, lhs, "", args)
end

---@param cmd string
MODULE.run_in_terminal = function(cmd)
    vim.cmd("terminal $SHELL -c " .. '"' .. cmd .. '"')
end

---@param enable boolean
---@param langs string|table|nil
---@return fun(): nil
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

---@param level integer
MODULE.statusline = function(level)
    vim.opt_local.laststatus = level
end

---@return string[]
MODULE.buffers_open = function()
    local buffers = {}

    ---@diagnostic disable-next-line: param-type-mismatch
    for buf_n = 1, vim.fn.bufnr("$") do
        if vim.fn.buflisted(buf_n) == 1 then
            table.insert(buffers, vim.fn.bufname(buf_n))
        end
    end
    return buffers
end

---@return string
MODULE.buffer_current = function()
    ---@diagnostic disable-next-line: param-type-mismatch
    return vim.fn.bufname("%")
end

---@param opts {absolute: boolean}
---@return string
MODULE.cwd = function(opts)
    local c = vim.fn.getcwd()
    if opts.absolute then
        return vim.fn.fnamemodify(c, ":p")
    end
    return c
end

MODULE.augroup = {}

---@return string[]
MODULE.augroup.names = function()
    local gnames = {}
    for _, ginfo in ipairs(vim.api.nvim_get_autocmds({})) do
        local gname = ginfo.group_name
        if not util.has_value(gnames, gname) then
            table.insert(gnames, gname)
        end
    end
    return gnames
end

---@param name string
---@return boolean
MODULE.augroup.has_name = function(name)
    if util.has_value(MODULE.augroup.names(), name) then
        return true
    end
    return false
end

return MODULE
