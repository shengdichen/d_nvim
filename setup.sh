#!/usr/bin/env dash

SCRIPT_PATH="$(realpath "$(dirname "${0}")")"
cd "${SCRIPT_PATH}" || exit 3

__install() {
    local _update
    if [ "${1}" = "--update" ]; then
        _update="yes"
    fi
    shift

    if [ ! -d "${2}" ]; then
        __clone "${1}" "${2}"
    else
        if [ "${_update}" ]; then
            __update "${2}"
        fi
    fi
}

__clone() {
    local _link="https://github.com/${1}/${2}.git"

    echo "clone> ${_link}"
    if ! git clone --depth 3 "${_link}"; then
        echo "clone> [${_link}] failed, bad internet/permission/address? (exiting)"
        exit 3
    fi
}

__update() {
    (
        cd "${1}" || exit 3
        echo "update> ${1}"
        if ! (git fetch && git merge); then
            echo "update> failed, bad internet? (exiting)"
            exit 3
        fi
    )
}

__plugin() {
    local _update="${1}"
    shift

    __lsp() {
        __install "${_update}" "neovim" "nvim-lspconfig"
        __install "${_update}" "nvimtools" "none-ls.nvim"

        __install "${_update}" "folke" "neodev.nvim"
        __install "${_update}" "j-hui" "fidget.nvim"
    }

    __snippet() {
        __install "${_update}" "L3MON4D3" "LuaSnip"
        (
            # REF:
            #   https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#transformations
            cd "./LuaSnip" || exit 3
            if [ ! -e "./lua/luasnip-jsregexp.lua" ] ||
                [ ! -e "./deps/luasnip-jsregexp.so" ]; then
                make install_jsregexp
            fi
        )

        # snippets collection
        __install "${_update}" "rafamadriz" "friendly-snippets"
    }

    __completion() {
        __install "${_update}" "hrsh7th" "nvim-cmp"

        # integration with neovim's (builtin) lsp
        __install "${_update}" "hrsh7th" "cmp-nvim-lsp"

        # integration with luasnip
        __install "${_update}" "saadparwaiz1" "cmp_luasnip"
    }

    __syntax() {
        __install "${_update}" "nvim-treesitter" "nvim-treesitter"
        __install "${_update}" "lukas-reineke" "indent-blankline.nvim"
    }

    __misc() {
        __install "${_update}" "nvim-lua" "plenary.nvim"
        __install "${_update}" "lewis6991" "gitsigns.nvim"

        __install "${_update}" "tpope" "vim-surround"
        __install "${_update}" "vifm" "vifm.vim"
    }

    (
        cd "./.config/nvim/conf/rpre/pack/start/start" || exit 3

        __lsp
        __snippet
        __completion
        __syntax
        __misc

    )
    unset -f __lsp __snippet __completion __syntax __misc
}

__stow() {
    (
        cd .. && stow -R "$(basename "${SCRIPT_PATH}")"
    )
}

main() {
    local _update
    case "${1}" in
        "--update" | "-u")
            _update="--update"
            shift
            ;;
    esac

    __plugin "${_update}"
    __stow

    unset SCRIPT_PATH
    unset -f __clone __plugin __stow
}
main "${@}"
unset -f main
