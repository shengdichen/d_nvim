call plug#begin()

" {{{
" give the status-line a modern touch
Plug 'itchyny/lightline.vim'

" the solution to brackets management
Plug 'tpope/vim-surround'

" the integrated filepicker in from of Vifm
Plug 'vifm/vifm.vim'

" the ultimate navigator
Plug 'easymotion/vim-easymotion'


" Language Server Clients {{{
" ALE {{{
" do NOT auto-trigger ALE's internal completion engine when typing
" NOTE: 0 (off) is the default and can thus be comfortably omitted; however,
" 1(on) must be set BEFORE loading ALE
let g:ale_completion_enabled = 0
"
Plug 'dense-analysis/ale'
" }}}

"       " LSP {{{
"       " neovim's default lsp-client
"       Plug 'neovim/nvim-lspconfig'
"       " }}}

"       " CoC {{{
"       Plug 'neoclide/coc.nvim', {'branch': 'release'}
"       " }}}
" }}}
" }}}

call plug#end()

