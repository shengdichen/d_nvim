local function bind()
    vim.keymap.set("c", ":V", "Vifm")
    vim.keymap.set("c", ":T", "TabVifm")
end

local function main()
    bind()
end
main()
