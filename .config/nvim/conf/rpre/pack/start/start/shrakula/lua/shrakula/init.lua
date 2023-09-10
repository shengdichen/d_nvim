local function check_version()
    if vim.version().minor < 7 then
        vim.notify_once("Update neovim to >= v0.7")
        return false
    end
    return true
end

local function setup_vim()
    if vim.g.colors_name then
        vim.cmd("highlight clear")
    end

    if vim.fn.exists("syntax_on") then
        vim.cmd("syntax reset")
    end

    vim.o.background = "dark"
    vim.o.termguicolors = true
    vim.g.colors_name = "shrakula"
end

local function main()
    if not check_version() then return end
    setup_vim()

    local palette = require("shrakula.palette")
    require("shrakula.color_true")(palette)
    require("shrakula.color_16")(palette)
end

return main
