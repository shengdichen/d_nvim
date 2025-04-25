Import-Module "$HOME\.local\lib\allumette\git.ps1" -Force

$DIR_CONFIG = "$env:LOCALAPPDATA\nvim"
$DIR_PLUGIN = "$DIR_CONFIG\rpre\pack\start\start"
$USE_MSYS = $false

function CopyConfig
{
    New-Item $DIR_CONFIG -ItemType Directory -ErrorAction SilentlyContinue
    New-Item $DIR_PLUGIN -ItemType Directory -ErrorAction SilentlyContinue

    Copy-Item ".\common\*" $DIR_CONFIG -Recurse -Force
    Copy-Item ".\windows\*" $DIR_CONFIG -Recurse -Force
}

function PluginLang
{
    Push-Location $DIR_PLUGIN

    # NOTE:
    #   must download lsp-files separately for powershell
    # REF:
    #   https://github.com/PowerShell/PowerShellEditorServices/releases

    GitClone "neovim" "nvim-lspconfig"
    GitClone "nvimtools" "none-ls.nvim"
    GitClone "nvimtools" "none-ls-extras.nvim"
    GitClone "Hoffs" "omnisharp-extended-lsp.nvim"
    GitClone "ThePrimeagen" "refactoring.nvim"

    GitClone "folke" "neodev.nvim"
    GitClone "j-hui" "fidget.nvim"

    Pop-Location
}

function PluginSnippet
{
    Push-Location $DIR_PLUGIN

    GitClone "L3MON4D3" "LuaSnip"
    Push-Location "./LuaSnip"
    if (
        !(Test-Path "./lua/luasnip-jsregexp.lua") -or
        !(Test-Path "./deps/luasnip-jsregexp.so")
    )
    {
        if ($USE_MSYS)
        {
            powershell -Command {
                $env:LUA_LDLIBS="C:\msys64\ucrt64\bin\lua51.dll";
                make install_jsregexp
            }
        } else
        {
            make install_jsregexp
        }
    }
    Pop-Location

    GitClone "rafamadriz" "friendly-snippets"
    Pop-Location
}

function PluginCompletion
{
    Push-Location $DIR_PLUGIN

    GitClone "hrsh7th" "nvim-cmp"
    GitClone "hrsh7th" "cmp-nvim-lsp"
    GitClone "saadparwaiz1" "cmp_luasnip"

    Pop-Location
}

function PluginVisual
{
    Push-Location $DIR_PLUGIN

    GitClone "nvim-treesitter" "nvim-treesitter"
    function RunNvim
    {
        nvim -c "set nomore | TSUpdateSync | q"

        # NOTE:
        #   must relaunch to actually install the languages
        nvim -c "q"
    }
    RunNvim

    GitClone "lukas-reineke" "indent-blankline.nvim"
    GitClone "numToStr" "Comment.nvim"

    GitClone "nvim-lua" "plenary.nvim"
    GitClone "lewis6991" "gitsigns.nvim"

    Pop-Location
}

function PluginMisc
{
    Push-Location $DIR_PLUGIN

    GitClone "tpope" "vim-surround"
    GitClone "vifm" "vifm.vim"
    GitClone "nvim-telescope" "telescope.nvim"

    GitClone "nvim-telescope" "telescope-fzf-native.nvim"
    Push-Location "./telescope-fzf-native.nvim"
    if (!(Test-Path "./build/libfzf.dll"))
    {
        if ($USE_MSYS)
        {
            powershell -Command {
                $env:MSYSTEM="MSYS"; make
            }
        } else
        {
            make
        }
    }
    Pop-Location

    Pop-Location
}

function Main
{
    CopyConfig

    PluginLang
    PluginSnippet
    PluginCompletion
    PluginVisual
    PluginMisc
}
Main
