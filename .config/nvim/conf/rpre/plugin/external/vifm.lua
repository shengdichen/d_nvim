local function conf()
    vim.g.vifm_embed_cwd = true
    vim.g.vifm_exec_args = "-c 'source $VIFM/conf/misc/nvim.vifm'"
end

local function bind()
    vim.keymap.set("c", ":V", "Vifm")
    vim.keymap.set("c", ":S", "SplitVifm")
end

local function main()
    conf()
    bind()
end
main()
