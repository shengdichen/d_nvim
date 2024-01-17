#!/usr/bin/env dash

SCRIPT_PATH="$(realpath "$(dirname "${0}")")"
cd "${SCRIPT_PATH}" || exit 3

__clone() {
    _link="https://github.com/${1}/${2}.git"

    if [ ! -d "${2}" ]; then
        # cater for failed cloning (bad permission, wrong address...)
        if ! git clone "${_link}"; then
            echo "Cloning [${_link}] failed, exiting"
            exit 3
        fi
    fi
}

__plugin() {
    (
        cd "./.config/nvim/conf/rpre/pack/start/start" || exit 3

        __clone "tpope" "vim-surround"
        __clone "vifm" "vifm.vim"

        __clone "neovim" "nvim-lspconfig"
        __clone "nvim-treesitter" "nvim-treesitter"

        __clone "hrsh7th" "nvim-cmp"
        # cmp integration with neovim's (builtin) lsp
        __clone "hrsh7th" "cmp-nvim-lsp"

        __clone "L3MON4D3" "LuaSnip"
        # cmp integration with luasnip
        __clone "saadparwaiz1" "cmp_luasnip"
        # snippets collection
        __clone "rafamadriz" "friendly-snippets"

        __clone "nvim-lua" "plenary.nvim"
        __clone "nvimtools" "none-ls.nvim"

        __clone "lewis6991" "gitsigns.nvim"
        __clone "lukas-reineke" "indent-blankline.nvim"
        __clone "folke" "neodev.nvim"
        __clone "j-hui" "fidget.nvim"

        # REF:
        #   https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#transformations
        cd "./LuaSnip" || exit 3
        if [ ! -e "./lua/luasnip-jsregexp.lua" ] || [ ! -e "./deps/luasnip-jsregexp.so" ]; then
            make install_jsregexp
        fi
    )
}

__stow() {
    (
        cd .. && stow -R "$(basename "${SCRIPT_PATH}")"
    )
}

main() {
    __plugin
    __stow

    unset SCRIPT_PATH
    unset -f __clone __plugin __stow
}
main
unset -f main
