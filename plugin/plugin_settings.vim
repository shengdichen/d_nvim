" dracula, et al. [deprecated in light of emergence of Shrakula] {{{
"
"       colorscheme dracula
"
"       " apply a touch of customization towards ultimate aesthetics:
"       " {{{
"       " embrace the true darkness
"       let g:dracula#palette.bg            = ['#000000', 16]
"
"       " color in Visual-* mode
"       let g:dracula#palette.selection     = ['#44475A', 239]
"
"       " make background of the current cursorline less instrusive and more subdued
"       let g:dracula#palette.subtle        = ['#293339', 236]
"
"       " add two more shades of grey for lightline
"       let g:dracula#palette.less_focus    = ['#44475A', 245]
"       let g:dracula#palette.bare_focus    = ['#44475A', 242]
"       " }}}
"
" }}}



" lightline {{{
" view help for the type "Dictionary" with:
"       :help eval.txt
"       :help Dictionaries



" set the colorscheme of lightline with:
"       let g:lightline.colorscheme='<myScheme>'

let g:lightline = {
    \   'colorscheme': 'shrakula_lightline',
    \
    \	'active': {
    \     	'right': [['mode'], ['lineInfo'], ['ro-mod', 'ro-umod', 'uro-mod'], ['is_modified']],
    \   	'left': [['about_file']]
    \   },
    \
    \   'inactive': {
    \     	'right': [['is_modified']],
    \     	'left': [['about_file']]
    \   },
    \
    \   'tabline': {
    \     	'left': [['tabs']],
    "\ display nothing on the right
    \       'right': []
    "\ the default
    "\       'right': [['close']]
    \   },
    \
    \   'tab': {
    \     	'active': ['filename'],
    \     	'inactive': ['filename']
    \   },
    \
    \   'component': {
    "\  right side {{{
    "\      do NOT display current mode when in normal-mode
    \       'mode': '%{lightline#mode()!="n"?lightline#mode():""}',
    \       'lineInfo': '(%02v, %03l/%03L) ~%03p%%',
    "\  requires unicode
    "\       'lineInfo': ' Nº(%03l,%02v)/∑%03L ≅ %03p%%',
    \		'ro-mod': '%{&readonly && &modifiable?"⌈!RO⌋":""}',
    \		'ro-umod': '%{&readonly && !&modifiable?"⌈!RO ∧ ¬W⌋":""}',
    \		'uro-mod': '%{!&readonly && !&modifiable?"⌈¬W⌋":""}',
    \       'is_modified': '%{&modified?"[pending overwrite...]":""}',
    "\  }}}
    \
    "\  left side {{{
    \		'about_file': '⟨%-.67F⟩ ≛ %{&ft!=#""?"⋆.".&ft:"voidType"}',
    "\  }}}
    \
    \       'filename': '%t',
    \       'close': '%999X xxx ', 'winnr': '%{winnr()}',
    \
    \       'separator_line': '--------------------------',
    \
    \       'absolutepath': '%F',
    \       'relativepath': '%f',
    \       'modified': '%M',
    \       'bufnum': '%n',
    \       'paste': '%{&paste?"PASTE":""}',
    \       'readonly': '%R',
    \       'charvalue': '%b',
    \       'charvaluehex': '%B',
    \       'spell': '%{&spell?&spelllang:""}',
    \       'fileencoding': '%{&fenc!=#""?&fenc:&enc}',
    \       'fileformat': '%{&ff}',
    \       'percent': '%03p',
    \       'percentwin': '%P',
    \       'column': '%c',
    \   },
    \
    \   'component_visible_condition': {
    \		'ro-mod': '!&readonly && &modifiable',
    \		'ro-umod': '&readonly && !&modifiable',
    \		'uro-mod': '!&readonly && &modifiable',
    \
    \		'is_modified': '&modified',
    \		'paste': '&paste',
    \		'spell': '&spell'
    \   },
    \
    \   'component_function': {
    \	},
    \
    \   'component_function_visible_condition': {
    \   },
    \
    \   'component_expand': {
    \     	'tabs': 'lightline#tabs'
    \   },
    \
    \   'component_type': {
    \     	'tabs': 'tabsel',
    \       'close': 'raw'
    \   },
    \
    \   'component_raw': {},
    \
    \   'tab_component': {},
    \
    \   'tab_component_function': {
    \     	'filename': 'lightline#tab#filename', 'modified': 'lightline#tab#modified',
    \     	'readonly': 'lightline#tab#readonly', 'tabnum': 'lightline#tab#tabnum'
    \   },
    \
    "\  displayed strings for different modes
    \   'mode_map': {
    \       'n': 'N',
    \       'i': 'I',
    \		'c': 'C',       't': 'T',
    \       'v': 'V',       'V': 'V-L', 	"\<C-v>": 'V-B',
    \       'R': 'R',
    \       's': 'S',       'S': 'S-L', 	"\<C-s>": 'S-B'
    \   },
    \
    \   '_mode_': {
    \     'n': 'normal', 'i': 'insert', 'R': 'replace', 'v': 'visual', 'V': 'visual', "\<C-v>": 'visual',
    \     'c': 'command', 's': 'select', 'S': 'select', "\<C-s>": 'select', 't': 'terminal'
    \   },
    \
    \   'mode_fallback': { 'replace': 'insert', 'terminal': 'insert', 'select': 'visual' },
    \
    \   'separator': { 'left': '', 'right': '' },
    \
    \   'subseparator': { 'left': '', 'right': '' },
    \
    \   'tabline_separator': {},
    \
    \   'tabline_subseparator': {},
    \
    \   'enable': { 'statusline': 1, 'tabline': 1 },
    \
    \   'palette': {},
    \
    \   'winwidth': winwidth(0),
    \ }
" }}}



" easymotion {{{
" default coloring in Shrakula {{{
" the following highlighting groups and their specific coloring are the
" defaults of Shrakula, i.e., they are incorporated in the Shrakula theme

" edit the highlighting requires them to be loaded after visual_aid.vim
"       " close target accessible with single-char key
"       hi! EasyMotionTarget ctermbg=16 ctermfg=219
"                   \ gui=none guibg=#000000 guifg=#ffafff
"
"       " chars not used to display keys are shaded in this color
"       hi! EasyMotionShade  ctermbg=16 ctermfg=239
"                   \ gui=none guibg=#000000 guifg=#4e4e4e
"
"
"       " the first char for far-away targets accessible with two-char keys
"       hi! EasyMotionTarget2First ctermbg=16 ctermfg=117
"                   \ gui=none guibg=#000000 guifg=#87d7ff
"
"       " the second char for far-away targets accessible with two-char keys
"       hi! EasyMotionTarget2Second ctermbg=16 ctermfg=67
"                   \ gui=none guibg=#000000 guifg=#5f87af
"
"
"       " when performing easy-motion specific searching
"       hi! EasyMotionIncSearch ctermbg=141 ctermfg=52
"                   \ gui=none guibg=#af87ff guifg=#5f0000
"
"       hi! EasyMotionMoveHL ctermbg=1 ctermfg=16
"                   \ gui=none guibg=#800000 guifg=#000000
" }}}


" mapping {{{
" map easymotion-leader to <space> (default was <space><space>)
nnoremap <Leader> <Plug>(easymotion-prefix)


" nmap for [N]ormal, xmap for Visual, omap for [O]perator-pending

" w for [w]ord
nmap <Leader>w <Plug>(easymotion-bd-w)
xmap <Leader>w <Plug>(easymotion-bd-w)
omap <Leader>w <Plug>(easymotion-bd-w)

nmap <Leader>b <Plug>(easymotion-bd-w)
xmap <Leader>b <Plug>(easymotion-bd-w)
omap <Leader>b <Plug>(easymotion-bd-w)

" W for [Word]
nmap <Leader>W <Plug>(easymotion-bd-W)
xmap <Leader>W <Plug>(easymotion-bd-W)
omap <Leader>W <Plug>(easymotion-bd-W)

nmap <Leader>B <Plug>(easymotion-bd-W)
xmap <Leader>B <Plug>(easymotion-bd-W)
omap <Leader>B <Plug>(easymotion-bd-W)

" e for [e]nd
nmap <Leader>e <Plug>(easymotion-bd-e)
xmap <Leader>e <Plug>(easymotion-bd-e)
omap <Leader>e <Plug>(easymotion-bd-e)

nmap <Leader>ge <Plug>(easymotion-bd-e)
xmap <Leader>ge <Plug>(easymotion-bd-e)
omap <Leader>ge <Plug>(easymotion-bd-e)

" E for [E]nd
nmap <Leader>E <Plug>(easymotion-bd-E)
xmap <Leader>E <Plug>(easymotion-bd-E)
omap <Leader>E <Plug>(easymotion-bd-E)

nmap <Leader>gE <Plug>(easymotion-bd-E)
xmap <Leader>gE <Plug>(easymotion-bd-E)
omap <Leader>gE <Plug>(easymotion-bd-E)


" f for [F]ind
nmap <Leader>f <Plug>(easymotion-bd-f)
xmap <Leader>f <Plug>(easymotion-bd-f)
omap <Leader>f <Plug>(easymotion-bd-f)

nmap <Leader>F <Plug>(easymotion-bd-f2)
xmap <Leader>F <Plug>(easymotion-bd-f2)
omap <Leader>F <Plug>(easymotion-bd-f2)

" t for [t]ill
nmap <Leader>t <Plug>(easymotion-bd-t)
xmap <Leader>t <Plug>(easymotion-bd-t)
omap <Leader>t <Plug>(easymotion-bd-t)

nmap <Leader>T <Plug>(easymotion-bd-t2)
xmap <Leader>T <Plug>(easymotion-bd-t2)
omap <Leader>T <Plug>(easymotion-bd-t2)

" s for bidirectional [s]earch of any character length
nmap <Leader>s <Plug>(easymotion-sn)
xmap <Leader>s <Plug>(easymotion-sn)
omap <Leader>s <Plug>(easymotion-sn)

" n/N for [n]/[N]ext
nmap <Leader>n <Plug>(easymotion-bd-n)
xmap <Leader>n <Plug>(easymotion-bd-n)
omap <Leader>n <Plug>(easymotion-bd-n)

nmap <Leader>N <Plug>(easymotion-bd-n)
xmap <Leader>N <Plug>(easymotion-bd-n)
omap <Leader>N <Plug>(easymotion-bd-n)


" line-wise operations
nmap <Leader>j <Plug>(easymotion-sol-bd-jk)
xmap <Leader>j <Plug>(easymotion-sol-bd-jk)
omap <Leader>j <Plug>(easymotion-sol-bd-jk)

nmap <Leader>k <Plug>(easymotion-sol-bd-jk)
xmap <Leader>k <Plug>(easymotion-sol-bd-jk)
omap <Leader>k <Plug>(easymotion-sol-bd-jk)
" }}}


" keep cursor column when switching rows with the line-wise operations above
let g:EasyMotion_startofline = 0
" }}}



" ALE {{{
" all languages {{{
" preparation {{{
" start with an empty dict for linters and fixers
let g:ale_linters = {}
let g:ale_fixers = {}

" to overrule ALL existing linters, assign with a new dict:
"       let g:ale_linters = {'cpp': 'all'}
" to modify a key's entry OR add a new key with its entry:
"       let g:ale_linters['cpp'] = 'all'

" to view currently enabled linters and fixers:
"       :ALEInfo


" to view fixers as suggested by ALE:
"       :ALEFixSuggest
"       let g:ale_fixers = {'cpp': ['clang-format', 'clangtidy']}
" }}}


" C-Family {{{
" C++ {{{
" optionally, use GNU compilers with g++
let g:ale_cpp_cc_executable = 'clang++'
let g:ale_cpp_cc_options = '-std=c++17 -Wall'

"   1.  clangd [LS]
"           pacman -S clangd
"   2.  ccls [LS]
"           pacman -S ccls

" clangtidy is a linter, but may also function as a fixer:
"   1.  to anaylize the file:
"       clang-tidy <my_file.cpp>
"   2.  to fix file
"       i.  stop with compilation errors
"       clang-tidy --fix <my_file.cpp>
"       ii. do NOT stop with compilation errors
"       clang-tidy --fix-errors <my_file.cpp>


" use clang-format as fixer
"     $ clang-format --style=webkit <my_file.cpp>


" clangd embed clang-tidy checks, rendering it redundant
let g:ale_linters['cpp'] = ['clangd']

let g:ale_fixers['cpp'] = ['clangtidy', 'clang-format']
let g:ale_cpp_clangtidy_extra_options = ""
" }}}

" cuda {{{
let g:ale_linters['cuda'] = ['nvcc']
"       let g:ale_cuda_nvcc_executable =
"           \ "/home/shengdi/mnt/FUSE/ptr/HPi7/opt/cuda/bin/nvcc"

let g:ale_fixers['cuda'] = ['clang-format']
" }}}

" C {{{
let g:ale_linters['c'] = 'all'
" }}}
" }}}


" python {{{
"   1.  pylint [Linter]
"       install with:
"         # pacman -S python-pylint
"       OR
"           pip install pylint
"       if using pip for locally install, need to explicitly set the location
"       of the executable:
"           let g:ale_python_pylint_executable = "~/.local/bin/pylint"
"       OR, add(append) ~/.local/bin to $PATH

"   2.  flake8 [Linter]
"       install with:
"         $ sudo pip install flake8

"   3.  pyls [LS]
"       install with
"           sudo pacman -S python-language-server
let g:ale_linters['python'] = ['pyls']
let g:ale_python_pyls_config = {
    \   'pyls': {
    \       'plugins': {
    \           'pycodestyle': {
    \               'enabled': v:false,
    \               'maxLineLength': 79,
    \           },
    \           'flake8': {
    \               'maxLineLength': 79,
    \           },
    \       },
    \   },
    \ }





"   3.  black [Fixer]
"         $ pip install black
"         $ sudo pacman -S python-black
"   4.  autopep8 [Fixer]
"         # pacman -S autopep8
"         $ pip install autopep8
let g:ale_fixers['python'] = ['black']
let g:ale_python_black_options = '--line-length 80'

" install jedi directly:
"       sudo pacman -S jedi
" Python LS by Palantir
"       sudo pip install python-language-server

" }}}


" shell {{{
" language_server := bash-language-server
let g:ale_linters['sh'] = ['shellcheck', 'language_server']

let g:ale_fixers['sh'] = ['shfmt']
" }}}


" cmake {{{
"   1.  cmakelint [Linter]
"       install with:
"           sudo pip install cmakelint
let g:ale_linters['cmake'] = ['cmakelint']

"   2.  cmake_format [Fixer]
"       install with:
"           sudo pip install cmake-format
"       which includes:
"           cmake-format
"           cmakelang
let g:ale_fixers['cmake'] = ['cmakeformat']
" }}}


" vimls {{{
"   1.  vimls
"       Official Repo at:
"           https://github.com/iamcco/vim-language-server
"       npm install -g vim-language-server

let g:ale_linters['vim'] = ['vimls']
" }}}


" *TeX {{{
"   1.  texlab
"     # pacman -S texlab

" general text files {{{
"   1.  write-good
"       install with:
"         $ npm install -g write-good

"   2.  alex
"       install with:
"         $ npm install -g alex
"
"   3.  proselint
"       install with
"           pacman -S proselint
" }}}


let g:ale_linters['tex'] = ['texlab', 'writegood', 'alex', 'proselint']
" }}}


" all other unnominated types {{{
let g:ale_linters['*'] = ['writegood', 'alex', 'proselint']
let g:ale_fixers['*'] = ['textlint']
" }}}
" }}}



" Message display {{{
" when cursor is near a warning or error, display a truncated message about it
let g:ale_echo_cursor = 1
" milliseconds before the aforementioned message is displayed
let g:ale_echo_delay = 0
" do NOT automatically display the aforementioned message as ALE-preview
" achieve this with :ALEDetail instead
let g:ale_cursor_detail = 0


" content of the aforementioned message
"   %s           - replaced with the text for the problem
"   %...code...% - replaced with the error code
"   %linter%     - replaced with the name of the linter
"   %severity%   - replaced with the severity of the problem
let g:ale_echo_msg_format = '%linter%.%severity%->(%s) % @[code]%'

" severity settings
let g:ale_echo_msg_error_str = "Er"
let g:ale_echo_msg_info_str = "In"
let g:ale_echo_msg_warning_str = "Wn"
" }}}


" mappings {{{
" navigations {{{
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
" }}}



" completion {{{
" (manually) trigger ALE's completion, consciously separated from Vim's completion
imap <C-Space> <Plug>(ale_complete)


" settings for completion {{{
" generally not required, included for safety only; documentation at:
"   ale-completion-completeopt-bug
" menuone   display completion-menu even if there is only one match
" preview   preview the currently selected completion
set completeopt=menu,menuone,preview


" NOTE: this somehow breaks the completion system, use a mapping for
" <Plug>(ale_complete) instead
"       set omnifunc=ale#completion#OmniFunc


"       " allow some transparency for the completion menu
"       set pumblend=20


" maximum number of itmes displayed in the completion menu using ALE
let g:ale_completion_max_suggestions = 10
" }}}
" }}}


" documentation
" H as in Help, capitalized!
nmap <Leader>H <Plug>(ale_documentation)


" hover {{{
" the high-level wrapper function for ALE's hovering mechanism
"       <Plug>(ale_hover)`
" h as in help
nmap <Leader>h <Plug>(ale_hover)

" do NOT automatically display (truncated) information about the symbol that
" the cursor is on
let g:ale_hover_cursor = 0

" display hover information in a preview window instead of in ballons
let g:ale_hover_to_preview = 1
" }}}


" open up another buffer to display extra information, e.g.:
"       ALEFindReferences
" and
"       ALEGoToDefinition
let g:ale_default_navigation='buffer'

" definition {{{
"       `<Plug>(ale_go_to_definition)`           - `:ALEGoToDefinition`
"       `<Plug>(ale_go_to_definition_in_tab)`    - `:ALEGoToDefinition -tab`
"       `<Plug>(ale_go_to_definition_in_split)`  - `:ALEGoToDefinition -split`
"       `<Plug>(ale_go_to_definition_in_vsplit)` - `:ALEGoToDefinition -vsplit`
nmap <Leader>dd <Plug>(ale_go_to_definition)
nmap <Leader>dt <Plug>(ale_go_to_definition_in_tab)
nmap <Leader>ds <Plug>(ale_go_to_definition_in_spit)
nmap <Leader>dv <Plug>(ale_go_to_definition_in_vsplit)

" type_definition
"       `<Plug>(ale_go_to_type_definition)`           - `:ALEGoToTypeDefinition`
"       `<Plug>(ale_go_to_type_definition_in_tab)`    - `:ALEGoToTypeDefinition -tab`
"       `<Plug>(ale_go_to_type_definition_in_split)`  - `:ALEGoToTypeDefinition -split`
"       `<Plug>(ale_go_to_type_definition_in_vsplit)` - `:ALEGoToTypeDefinition -vsplit`
nmap <Leader>DD <Plug>(ale_go_to_type_definition)
nmap <Leader>DT <Plug>(ale_go_to_type_definition_in_tab)
nmap <Leader>DS <Plug>(ale_go_to_type_definition_in_split)
nmap <Leader>DV <Plug>(ale_go_to_type_definition_in_vsplit)
" }}}

" reference {{{
" by default only one plug mapping
"       <Plug>(ale_find_references)     - ALEFindReferences
nmap <Leader>r <Plug>(ale_find_references)

" unnamed functions
"       "       ALEFindReferences -relative     - show relative paths of referencing files
"       "       ALEFindReferences -tab          - Open the location in a new tab.
"       "       ALEFindReferences -split        - Open the location in a horizontal split.
"       "       ALEFindReferences -vsplit       - Open the location in a vertical split.
"       nnoremap <silent>
"           \ <Plug>(ale_find_references_relative)
"           \ :ALEFindReferences -relative<Return>
"
"       nnoremap <silent>
"           \ <Plug>(ale_find_references_relative_in_tab)
"           \ :ALEFindReferences -relative -tab<Return>
"
"       nnoremap <silent>
"           \ <Plug>(ale_find_references_relative_in_split)
"           \ :ALEFindReferences -relative -split<Return>
"
"       nnoremap <silent>
"           \ <Plug>(ale_find_references_relative_in_vsplit)
"           \ :ALEFindReferences -relative -vsplit<Return>
" }}}
" }}}




" completion symbols {{{
"       let g:ale_completion_symbols = {
"       \ 'text': 'text',
"       \ 'method': 'method',
"       \ 'function': 'function',
"       \ 'constructor': 'ctor',
"       \ 'field': 'field',
"       \ 'variable': 'var',
"       \ 'class': 'class',
"       \ 'interface': 'interface',
"       \ 'module': 'module',
"       \ 'property': 'property',
"       \ 'unit': 'unit',
"       \ 'value': 'value',
"       \ 'enum': 'enum',
"       \ 'keyword': 'keyword',
"       \ 'snippet': 'snippet',
"       \ 'color': 'color',
"       \ 'file': 'file',
"       \ 'reference': 'ref',
"       \ 'folder': 'dir',
"       \ 'enum member': 'enum_member',
"       \ 'constant': 'const',
"       \ 'struct': 'struct',
"       \ 'event': 'event',
"       \ 'operator': 'optor',
"       \ 'type_parameter': 'type_param',
"       \ '<default>': 'def'
"       \ }
" }}}
" }}}



"       " LSP {{{
"       " language-specific configs {{{
"       " load settings for LSP
"       luafile ~/.config/nvim/LSP.lua
"
"       " use LSP with omni-completion
"       " NOTE: this must be put pretty late to avoid accidental overwrite
"       autocmd Filetype * setlocal omnifunc=v:lua.vim.lsp.omnifunc
"       " }}}
"
"
"       " default binds {{{
"       nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
"
"       nnoremap <silent> H     <cmd>lua vim.lsp.buf.hover()<CR>
"
"       nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
"
"       nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
"
"       nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
"
"       nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
"
"       nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
"
"       nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
"
"       nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
"       " }}}
"
"       " }}}



" default CoC seetings {{{
"       " setup {{{
"       " TextEdit might fail if hidden is not set.
"       set hidden
"
"       " Some servers have issues with backup files, see #649.
"       set nobackup
"       set nowritebackup
"
"       " Give more space for displaying messages.
"       set cmdheight=2
"
"       " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
"       " delays and poor user experience.
"       set updatetime=300
"
"       " Don't pass messages to |ins-completion-menu|.
"       set shortmess+=c
"
"       " Always show the signcolumn, otherwise it would shift the text each time
"       " diagnostics appear/become resolved.
"       if has("patch-8.1.1564")
"         " Recently vim can merge signcolumn and number column into one
"         set signcolumn=number
"       else
"         set signcolumn=yes
"       endif
"       " }}}
"
"
"
"       " selecting result from completion prompt; commented out due to:
"       "   1.  much more natural with <C-N> and <C-P> following Vim's
"       "       default completion
"       "   2.  the default check_back_space() function disables aggressive (explicit)
"       "       tabbing
"       "
"       "       " Use tab for trigger completion with characters ahead and navigate.
"       "       " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
"       "       " other plugin before putting this into your config.
"       "       inoremap <silent><expr> <TAB>
"       "             \ pumvisible() ? "\<C-n>" :
"       "             \ <SID>check_back_space() ? "\<TAB>" :
"       "             \ coc#refresh()
"       "
"       "       function! s:check_back_space() abort
"       "         let col = col('.') - 1
"       "         return !col || getline('.')[col - 1]  =~# '\s'
"       "       endfunction
"
"       "   if completion menu is visible, traverse positively; otherwise enter a
"       "   literal tab
"       inoremap <silent><expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
"       " if completion menu is visible, traverse the menu; otherwise no-op
"       inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : ""
"
"
"
"       "       " Use <c-space> to trigger completion.
"       "       if has('nvim')
"       "         inoremap <silent><expr> <c-space> coc#refresh()
"       "       else
"       "         inoremap <silent><expr> <c-@> coc#refresh()
"       "       endif
"
"
"       "       " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
"       "       " position. Coc only does snippet and additional edit on confirm.
"       "       " <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
"       "       if exists('*complete_info')
"       "         inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
"       "       else
"       "         inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"       "       endif
"
"
"
"       " Use `[g` and `]g` to navigate diagnostics
"       " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
"       nmap <silent> [g <Plug>(coc-diagnostic-prev)
"       nmap <silent> ]g <Plug>(coc-diagnostic-next)
"
"       " GoTo code navigation.
"       nmap <silent> gd <Plug>(coc-definition)
"       nmap <silent> gy <Plug>(coc-type-definition)
"       nmap <silent> gi <Plug>(coc-implementation)
"       nmap <silent> gr <Plug>(coc-references)
"
"
"
"       " Use K to show documentation in preview window.
"       "       nnoremap <silent> K :call <SID>show_documentation()<CR>
"       " a better mnenomic would be H, for Help
"       nnoremap <silent> H :call <SID>show_documentation()<CR>
"
"
"
"       function! s:show_documentation()
"         if (index(['vim','help'], &filetype) >= 0)
"           execute 'h '.expand('<cword>')
"         else
"           call CocAction('doHover')
"         endif
"       endfunction
"
"       " Highlight the symbol and its references when holding the cursor.
"       autocmd CursorHold * silent call CocActionAsync('highlight')
"
"       " Symbol renaming.
"       nmap <leader>rn <Plug>(coc-rename)
"
"       " Formatting selected code.
"       xmap <leader>f  <Plug>(coc-format-selected)
"       nmap <leader>f  <Plug>(coc-format-selected)
"
"       augroup mygroup
"         autocmd!
"         " Setup formatexpr specified filetype(s).
"         autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
"         " Update signature help on jump placeholder.
"         autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
"       augroup end
"
"       " Applying codeAction to the selected region.
"       " Example: `<leader>aap` for current paragraph
"       xmap <leader>a  <Plug>(coc-codeaction-selected)
"       nmap <leader>a  <Plug>(coc-codeaction-selected)
"
"       " Remap keys for applying codeAction to the current buffer.
"       nmap <leader>ac  <Plug>(coc-codeaction)
"       " Apply AutoFix to problem on the current line.
"       nmap <leader>qf  <Plug>(coc-fix-current)
"
"       " Map function and class text objects
"       " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
"       xmap if <Plug>(coc-funcobj-i)
"       omap if <Plug>(coc-funcobj-i)
"       xmap af <Plug>(coc-funcobj-a)
"       omap af <Plug>(coc-funcobj-a)
"       xmap ic <Plug>(coc-classobj-i)
"       omap ic <Plug>(coc-classobj-i)
"       xmap ac <Plug>(coc-classobj-a)
"       omap ac <Plug>(coc-classobj-a)
"
"       " Use CTRL-S for selections ranges.
"       " Requires 'textDocument/selectionRange' support of language server.
"       nmap <silent> <C-s> <Plug>(coc-range-select)
"       xmap <silent> <C-s> <Plug>(coc-range-select)
"
"       " Add `:Format` command to format current buffer.
"       command! -nargs=0 Format :call CocAction('format')
"
"       " Add `:Fold` command to fold current bffer.
"       command! -nargs=? Fold :call     CocAction('fold', <f-args>)
"
"       " Add `:OR` command for organize imports of the current buffer.
"       command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
"
"       " Add (Neo)Vim's native statusline support.
"       " NOTE: Please see `:h coc-status` for integrations with external plugins that
"       " provide custom statusline: lightline.vim, vim-airline.
"       set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
"       "
"       " Mappings for CoCList, for diagnostic purposes {{{
"       " Mappings for CoCList
"       " Show all diagnostics.
"       nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
"
"       " Manage extensions.
"       nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
"       " Show commands.
"       nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
"       " Find symbol of current document.
"       nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
"       " Search workspace symbols.
"       nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
"
"       " Do default action for next item.
"       nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
"       " Do default action for previous item.
"       nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
"       " Resume latest coc list.
"       nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>u
"       " }}}
" }}}



" netrw {{{
cnoremap :e split +Explore
cnoremap :E tabnew +Explore

" listing options {{{
" do not show the banner
" toggle with |netrw-I|
let g:netrw_banner = 0

" do not hide anything
" toggle with |netrw-a|
let g:netrw_hide = 0

" long listing (extra info)
" toggle with |netrw-i|
let g:netrw_liststyle = 1

" sorting {{{
" sort by name
" toggle with |netrw-s|
let g:netrw_sort_options = "name"

" sort in positive direction
" toggle with |netrw-r|
let g:netrw_sort_direction = "normal"
" }}}
" }}}

" follow netrw's browsing directory
" manually sync *vim's current dir with netrw with |netrw-c|
let g:netrw_keepdir = 1

" only reuse buffered listing for remote directories
" manually reload a directory with netrw-ctrl_l
let g:netrw_fastbrowse = 1

" opening files {{{
" preview in a vsplit (on the right! by default)
" NOTE: there is at most one preview window at any time
let g:netrw_preview = 1

" open files in current window (and consume it!) when hitting <CR>
let g:netrw_browse_split = 0

" :split =: netrw-o
" :vsplit =: netrw-v
" tabnew =: netrw-t

" preview =: netrw-p
" }}}
" }}}
