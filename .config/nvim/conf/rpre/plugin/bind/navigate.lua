-- NOTE:
--  1. find name for keys from |:h key-notation|

local _unbind         = require("bind")["unbind"]
local mode_nv, mode_i = { "n", "v" }, { "i" }

local function move_as_seen()
    -- NOTE:
    --  1. particularly useful for prose-form

    vim.keymap.set(mode_nv, "j", "gj")
    vim.keymap.set(mode_nv, "k", "gk")
    vim.keymap.set(mode_nv, "J", "4gj")
    vim.keymap.set(mode_nv, "K", "4gk")

    vim.keymap.set(mode_nv, "0", "g0")
    vim.keymap.set(mode_nv, "$", "g$")

    -- true beginning/end of lines, ignoring all leading/trailing spaces
    vim.keymap.set(mode_nv, "H", "g^")
    vim.keymap.set(mode_nv, "L", "g_")
end

local function unbind()
    _unbind(mode_nv, "<Up>")
    _unbind(mode_nv, "<Down>")
    _unbind(mode_nv, "<PageUp>")
    _unbind(mode_nv, "<PageUp>")
end

local function insert()
    _unbind(mode_i, "<PageUp>")
    _unbind(mode_i, "<PageDown>")

    vim.keymap.set(mode_i, "<C-h>", "<Left>")
    vim.keymap.set(mode_i, "<C-j>", "<Down>")
    vim.keymap.set(mode_i, "<C-k>", "<Up>")
    vim.keymap.set(mode_i, "<C-l>", "<Right>")

    vim.keymap.set(mode_i, "<C-b>", "<C-Left>")
    vim.keymap.set(mode_i, "<C-w>", "<C-Right>")

    vim.keymap.set(mode_i, "<C-e>", "<ScrollWheelDown>")
    vim.keymap.set(mode_i, "<C-y>", "<ScrollWheelUp>")
end

local function main()
    move_as_seen()
    unbind()
    insert()
end
main()
