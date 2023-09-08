local function bind()
    vim.keymap.set("c", ":V", "Vifm")
    vim.keymap.set("c", ":F", "TabVifm")
end

local function main()
    bind()
end
main()
