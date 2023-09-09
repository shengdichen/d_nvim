local function move_as_seen()
    -- NOTE:
    --  1. particularly useful for prose-form

    vim.keymap.set({"n", "v"}, "j", "gj")
    vim.keymap.set({"n", "v"}, "k", "gk")

    vim.keymap.set({"n", "v"}, "0", "g0")
    vim.keymap.set({"n", "v"}, "$", "g$")
end

local function vertical()
    vim.keymap.set({"n", "v"}, "J", "4j")
    vim.keymap.set({"n", "v"}, "K", "4k")

    vim.keymap.set({"n", "v"}, "<Up>", "")
    vim.keymap.set({"n", "v"}, "<Down>", "")
    vim.keymap.set({"n", "v"}, "<PageUp>", "")
    vim.keymap.set({"n", "v"}, "<PageUp>", "")
end

local function horizontal()
    -- the true beginning (end) of lines, ignoring all leading (trailing) spaces
    vim.keymap.set({"n", "v"}, "H", "g^")
    vim.keymap.set({"n", "v"}, "L", "g_")
end

local function main()
    move_as_seen()
    vertical()
    horizontal()

    -- TODO:
    --  move this somewhere else
    vim.opt.foldmethod = "indent"
end
main()
