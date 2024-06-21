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
        __install "${_update}" "nvimtools" "none-ls-extras.nvim"
        __install "${_update}" "Hoffs" "omnisharp-extended-lsp.nvim"
        __install "${_update}" "ThePrimeagen" "refactoring.nvim"

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
        __install "${_update}" "nvim-telescope" "telescope.nvim"

        __install "${_update}" "nvim-telescope" "telescope-fzf-native.nvim"
        (
            cd "telescope-fzf-native.nvim" || exit 3
            # REF:
            #   https://github.com/nvim-telescope/telescope-fzf-native.nvim/blob/main/README.md#installation
            if [ ! -e "build/libfzf.so" ]; then
                make
            fi
        )
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

__update_treesitter() {
    # NOTE:
    #   1. must use the sync variant
    #   2. no-more to prevent more-prompt
    nvim -c "set nomore | TSUpdateSync | q"
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
    __update_treesitter

    unset SCRIPT_PATH
    unset -f __install __clone __update __plugin __stow __update_treesitter
}
main "${@}"
unset -f main
