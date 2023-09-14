-- NOTE:
--  1. find name for keys from |:h key-notation|

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
    vim.keymap.set(modes, "<Up>", "")
    vim.keymap.set(modes, "<Down>", "")
    vim.keymap.set(modes, "<PageUp>", "")
    vim.keymap.set(modes, "<PageUp>", "")
end

local function insert()
    vim.keymap.set("i", "<PageUp>", "")
    vim.keymap.set("i", "<PageDown>", "")

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
