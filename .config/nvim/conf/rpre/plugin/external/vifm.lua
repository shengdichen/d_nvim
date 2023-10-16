local function bind()
    vim.keymap.set("c", ":V", "Vifm")
    vim.keymap.set("c", ":S", "SplitVifm")
end

local function main()
    bind()
end
main()
