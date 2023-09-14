-- NOTE:
--  1. find name for keys from |:h key-notation|

local _unbind = require("bind")["unbind"]

local modes = { "n", "v" }

local function move_as_seen()
    -- NOTE:
    --  1. particularly useful for prose-form

    vim.keymap.set(modes, "j", "gj")
    vim.keymap.set(modes, "k", "gk")
    vim.keymap.set(modes, "J", "4gj")
    vim.keymap.set(modes, "K", "4gk")

    vim.keymap.set(modes, "0", "g0")
    vim.keymap.set(modes, "$", "g$")

    -- true beginning/end of lines, ignoring all leading/trailing spaces
    vim.keymap.set(modes, "H", "g^")
    vim.keymap.set(modes, "L", "g_")
end

local function unbind()
    _unbind(modes, "<Up>")
    _unbind(modes, "<Down>")
    _unbind(modes, "<PageUp>")
    _unbind(modes, "<PageUp>")
end

local function insert()
    _unbind("i", "<PageUp>")
    _unbind("i", "<PageDown>")

    vim.keymap.set("i", "<C-h>", "<Left>")
    vim.keymap.set("i", "<C-j>", "<Down>")
    vim.keymap.set("i", "<C-k>", "<Up>")
    vim.keymap.set("i", "<C-l>", "<Right>")

    vim.keymap.set("i", "<C-b>", "<C-Left>")
    vim.keymap.set("i", "<C-w>", "<C-Right>")

    vim.keymap.set("i", "<C-e>", "<ScrollWheelDown>")
    vim.keymap.set("i", "<C-y>", "<ScrollWheelUp>")
end

local function main()
    move_as_seen()
    unbind()
    insert()
end
main()
