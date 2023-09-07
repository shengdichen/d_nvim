" =============================================================================
" Based on the original Dracula theme by adamalbrecht
" Filename: autoload/lightline/colorscheme/shrakula.vim
" Author: shengdichen
" License: MIT License
" Last Change: 23.May.2020
" =============================================================================


" load palette from SHRAKULA {{{
"   let s:black    = g:dracula#palette.bg
let s:black       = g:dracula#palette.better_bg

let s:grey        = g:dracula#palette.less_focus
let s:grey_more   = g:dracula#palette.bare_focus

"   let s:white    = g:dracula#palette.fg
let s:white       = g:dracula#palette.better_fg

" the colors
let s:darkblue    = g:dracula#palette.comment
let s:cyan        = g:dracula#palette.cyan
let s:green       = g:dracula#palette.green
let s:orange      = g:dracula#palette.orange
let s:purple      = g:dracula#palette.purple
let s:red         = g:dracula#palette.red
let s:yellow      = g:dracula#palette.yellow
" }}}



if exists('g:lightline')

  " all the different modes supported by lightline
  let s:p = {
          \ 'normal': {},
          \ 'insert': {},
          \ 'visual': {},
          \ 'replace': {},
          \ 'inactive': {},
          \ 'tabline': {}
        \ }


  " N_Mode {{{
  let s:p.normal.right = [
          \ [ s:black, s:white, 'bold' ],
          \ [ s:white, s:black ],
          \ [ s:orange, s:black ],
          \ [ s:red, s:black ]
        \ ]

  let s:p.normal.middle = [ [ s:white, s:black ] ]
  let s:p.normal.left = [ [ s:grey, s:black ], [ s:white, s:darkblue ] ]
  let s:p.normal.error = [ [ s:red, s:black ] ]
  let s:p.normal.warning = [ [ s:cyan, s:black ] ]
  " }}}

  " I_Mode {{{
  let s:p.insert.right = [
          \ [ s:black, s:white, 'bold'],
          \ [ s:white, s:black ],
          \ [ s:orange, s:black ],
          \ [ s:red, s:black ]
        \ ]
  " }}}

  " V_Mode {{{
  let s:p.visual.right= [
          \ [ s:black, s:white, 'bold' ],
          \ [ s:white, s:black ],
          \ [ s:orange, s:black ],
          \ [ s:red, s:black ]
        \]
  " }}}

  " R_Mode {{{
  let s:p.replace.right = [
          \ [ s:black, s:white, 'bold' ],
          \ [ s:white, s:black ],
          \ [ s:orange, s:black ],
          \ [ s:red, s:black ]
        \ ]
  " }}}

  " inactive {{{
  let s:p.inactive.right =  [
          \ [ s:red, s:black ],
          \ [ s:grey, s:black ],
          \ [ s:grey, s:black ],
          \ [ s:grey, s:black ]
        \ ]

  let s:p.inactive.middle = [ [ s:grey, s:black ] ]
  let s:p.inactive.left = [ [ s:grey_more, s:black ], [ s:grey, s:black ] ]
  " }}}

  " tab-line {{{
  let s:p.tabline.left = [ [ s:grey_more, s:black ] ]
  let s:p.tabline.middle = [ [ s:darkblue, s:black ] ]
  let s:p.tabline.right = [ [ s:black, s:black ] ]
  let s:p.tabline.right = copy(s:p.normal.right)
  let s:p.tabline.tabsel = [ [ s:black, s:white,'bold' ] ]
  " }}}


  " the format of "compiled" colorscheme files of lightline
  "     let s:p.{mode}.{where} = [ [ {guifg}, {guibg}, {ctermfg}, {ctermbg} ], ... ]
  " use |fill| or |flatten| to perform the "compilation", implemented in
  "     lightline.vim/autoload/lightline/colorscheme.vim
  " where |flatten| shall be used if BOTH true RGB and 256 colors are given
  "
  " or, do NOT compile and load as-hoc the palette as-is without compiling
  let g:lightline#colorscheme#shrakula_lightline#palette =
        \ lightline#colorscheme#flatten(s:p)

endif

" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0:

