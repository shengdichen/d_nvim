-- NOTE:
--  1. find name for keys from |:h key-notation|

local util_vim        = require("util_vim")
local mode_nv, mode_i = { "n", "v" }, { "i" }

local function navigate()
    local function move_as_seen()
        -- NOTE:
        --  1. particularly useful for prose-form

        vim.keymap.set(mode_nv, "j", "gj")
        vim.keymap.set(mode_nv, "k", "gk")
        vim.keymap.set(mode_nv, "J", "4gj")
        vim.keymap.set(mode_nv, "K", "4gk")

        vim.keymap.set(mode_nv, "0", "g0")
        vim.keymap.set(mode_nv, "$", "g$")
    end

    local function scroll_autocenter()
        for _, k in ipairs({ "u", "d", "b", "f" }) do
            local key = "<C-" .. k .. ">"
            vim.keymap.set(mode_nv, key, key .. "zz")
        end
    end

    local function unbind()
        util_vim.unbind(mode_nv, "<Up>")
        util_vim.unbind(mode_nv, "<Down>")
        util_vim.unbind(mode_nv, "<PageUp>")
        util_vim.unbind(mode_nv, "<PageUp>")
    end

    move_as_seen()
    scroll_autocenter()
    unbind()
end

local function insert()
    vim.keymap.set("i", "jj", "<ESC>")
    vim.keymap.set("n", "<S-CR>", 'o<Esc>0"_D') -- |"_| := blackhole-buffer

    util_vim.unbind(mode_i, "<PageUp>")
    util_vim.unbind(mode_i, "<PageDown>")

    vim.keymap.set(mode_i, "<C-h>", "<Left>")
    vim.keymap.set(mode_i, "<C-j>", "<Down>")
    vim.keymap.set(mode_i, "<C-k>", "<Up>")
    vim.keymap.set(mode_i, "<C-l>", "<Right>")

    vim.keymap.set(mode_i, "<C-b>", "<C-Left>")
    vim.keymap.set(mode_i, "<C-w>", "<C-Right>")

    vim.keymap.set(mode_i, "<C-e>", "<ScrollWheelDown>")
    vim.keymap.set(mode_i, "<C-y>", "<ScrollWheelUp>")
end

local function misc()
    vim.g.mapleader = " " -- |space| as leader-key
end

local function main()
    navigate()
    insert()
    misc()
end
main()
