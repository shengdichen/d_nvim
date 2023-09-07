" Shrakula Theme, based on the Dracula Theme {{{
"
" https://github.com/zenorocha/dracula-theme
"
" Copyright 2016, All rights reserved
"
" Code licensed under the MIT license
" http://zenorocha.mit-license.org
"
" @author Trevor Heins <@heinst>
" @author Éverton Ribeiro <nuxlli@gmail.com>
" @author Derek Sifford <dereksifford@gmail.com>
" @author Zeno Rocha <hi@zenorocha.com>
scriptencoding utf8
" }}}


" SHRAKULA-Palette: {{{
" define the SHRAKULA-Palette for convenient global usage

let g:dracula#palette           = {}
let g:dracula#palette.fg        = ['#F8F8F2', 253]

let g:dracula#palette.bglighter = ['#424450', 238]
let g:dracula#palette.bglight   = ['#343746', 237]
let g:dracula#palette.bg        = ['#282A36', 236]
let g:dracula#palette.bgdark    = ['#21222C', 235]
let g:dracula#palette.bgdarker  = ['#191A21', 234]

let g:dracula#palette.comment   = ['#6272A4',  61]
let g:dracula#palette.selection = ['#44475A', 239]
let g:dracula#palette.subtle    = ['#424450', 238]

let g:dracula#palette.cyan      = ['#8BE9FD', 117]
let g:dracula#palette.green     = ['#50FA7B',  84]
let g:dracula#palette.orange    = ['#FFB86C', 215]
let g:dracula#palette.pink      = ['#FF79C6', 212]
let g:dracula#palette.purple    = ['#BD93F9', 141]
let g:dracula#palette.red       = ['#FF5555', 203]
let g:dracula#palette.yellow    = ['#F1FA8C', 228]


" SHRAKULA-specifics {{{
" a better background, aka, true dark
let g:dracula#palette.better_bg   = ['#000000', 16]

" a better foreground
let g:dracula#palette.better_fg  = ['#ede3f7', 253]


" add two more shades of grey for lightline
let g:dracula#palette.less_focus    = ['#44475A', 245]
let g:dracula#palette.bare_focus    = ['#44475A', 242]
" }}}


"
" ANSI
"
let g:dracula#palette.color_0  = '#21222C'
let g:dracula#palette.color_1  = '#FF5555'
let g:dracula#palette.color_2  = '#50FA7B'
let g:dracula#palette.color_3  = '#F1FA8C'
let g:dracula#palette.color_4  = '#BD93F9'
let g:dracula#palette.color_5  = '#FF79C6'
let g:dracula#palette.color_6  = '#8BE9FD'
let g:dracula#palette.color_7  = '#F8F8F2'
let g:dracula#palette.color_8  = '#6272A4'
let g:dracula#palette.color_9  = '#FF6E6E'
let g:dracula#palette.color_10 = '#69FF94'
let g:dracula#palette.color_11 = '#FFFFA5'
let g:dracula#palette.color_12 = '#D6ACFF'
let g:dracula#palette.color_13 = '#FF92DF'
let g:dracula#palette.color_14 = '#A4FFFF'
let g:dracula#palette.color_15 = '#FFFFFF'

" }}}



" Setup: {{{
" generate local SHRAKULA-Groups with the global SHRAKULA-Palette

if v:version > 580
  " reset all existing highlight groups
  highlight clear
  if exists('syntax_on')
    " reset all syntax highlighting
    syntax reset
  endif
endif

" this MUST match the name of this filename for correct syntax highlighting
let g:colors_name = 'shrakula_theme'

if !(has('termguicolors') && &termguicolors) && !has('gui_running') && &t_Co != 256
  finish
endif

" setup local SHRAKULA-Palette: {{{2
" load global SHRAKULA-Palette into local SHRAKULA-Palette

let s:fg        = g:dracula#palette.fg

let s:bglighter = g:dracula#palette.bglighter
let s:bglight   = g:dracula#palette.bglight
let s:bg        = g:dracula#palette.bg
let s:bgdark    = g:dracula#palette.bgdark
let s:bgdarker  = g:dracula#palette.bgdarker

let s:comment   = g:dracula#palette.comment
let s:selection = g:dracula#palette.selection
let s:subtle    = g:dracula#palette.subtle

let s:cyan      = g:dracula#palette.cyan
let s:green     = g:dracula#palette.green
let s:orange    = g:dracula#palette.orange
let s:pink      = g:dracula#palette.pink
let s:purple    = g:dracula#palette.purple
let s:red       = g:dracula#palette.red
let s:yellow    = g:dracula#palette.yellow

let s:none      = ['NONE', 'NONE']

" personalized colors
let s:better_bg     = g:dracula#palette.better_bg
let s:better_fg    = g:dracula#palette.better_fg



if has('nvim')
  for s:i in range(16)
    let g:terminal_color_{s:i} = g:dracula#palette['color_' . s:i]
  endfor
endif

if has('terminal')
  let g:terminal_ansi_colors = []
  for s:i in range(16)
    call add(g:terminal_ansi_colors, g:dracula#palette['color_' . s:i])
  endfor
endif

" }}}2


" different style-attributes: {{{2

if !exists('g:dracula_bold')
  let g:dracula_bold = 1
endif

if !exists('g:dracula_italic')
  let g:dracula_italic = 1
endif

if !exists('g:dracula_underline')
  let g:dracula_underline = 1
endif

if !exists('g:dracula_undercurl') && g:dracula_underline != 0
  let g:dracula_undercurl = 1
endif

if !exists('g:dracula_inverse')
  let g:dracula_inverse = 1
endif

if !exists('g:dracula_colorterm')
  let g:dracula_colorterm = 1
endif

"}}}2


" Utility Routines: {{{2

" a dictionary holding all style-attributes
let s:attrs = {
      \ 'bold': g:dracula_bold == 1 ? 'bold' : 0,
      \ 'italic': g:dracula_italic == 1 ? 'italic' : 0,
      \ 'underline': g:dracula_underline == 1 ? 'underline' : 0,
      \ 'undercurl': g:dracula_undercurl == 1 ? 'undercurl' : 0,
      \ 'inverse': g:dracula_inverse == 1 ? 'inverse' : 0,
      \ }


" utility routine to generate a command in form of:
"     highlight |scope| guifg=|fg[0]| ctermfg=|fg[1]|
" to set a local, SHRAKULA-specific highlight group, with variadic arguments in
" the order of
"     bg, attr_list, special
function! s:h(scope, fg, ...)
  let l:fg = copy(a:fg)

  " return the 1st argument from variadic arugments OR ['NONE', 'NONE'] if such
  " argument non-exist
  let l:bg = get(a:, 1, ['NONE', 'NONE'])

  let l:attr_list = filter(get(a:, 2, ['NONE']), 'type(v:val) == 1')
  let l:attrs = len(l:attr_list) > 0 ? join(l:attr_list, ',') : 'NONE'

  " Falls back to coloring foreground group on terminals because
  " nearly all do not support undercurl
  let l:special = get(a:, 3, ['NONE', 'NONE'])
  if l:special[0] !=# 'NONE' && l:fg[0] ==# 'NONE' && !has('gui_running')
    let l:fg[0] = l:special[0]
    let l:fg[1] = l:special[1]
  endif

  " form the components of the final command in an array
  "   Note that |fg|, |bg|, |special| are all lists (arrays), where the first
  "   arguments of |fg| and |bg| are set to guifg and guibg, and the second to
  "   ctermfg and ctermbg
  let l:hl_string = [
        \ 'highlight', a:scope,
        \ 'guifg=' . l:fg[0], 'ctermfg=' . l:fg[1],
        \ 'guibg=' . l:bg[0], 'ctermbg=' . l:bg[1],
        \ 'gui=' . l:attrs, 'cterm=' . l:attrs,
        \ 'guisp=' . l:special[0],
        \]

  " generate the command
  execute join(l:hl_string, ' ')
endfunction

"}}}2


" generate SHRAKULA-Groups: {{{2
" use the utility routine above to generate all SHRAKULA-Groups

call s:h('DraculaBgLight', s:none, s:bglight)
call s:h('DraculaBgLighter', s:none, s:bglighter)
call s:h('DraculaBgDark', s:none, s:bgdark)
call s:h('DraculaBgDarker', s:none, s:bgdarker)

call s:h('DraculaFg', s:fg)
call s:h('DraculaFgUnderline', s:fg, s:none, [s:attrs.underline])
call s:h('DraculaFgBold', s:fg, s:none, [s:attrs.bold])

call s:h('DraculaComment', s:comment)
call s:h('DraculaCommentBold', s:comment, s:none, [s:attrs.bold])

call s:h('DraculaSelection', s:none, s:selection)

call s:h('DraculaSubtle', s:subtle)

call s:h('DraculaCyan', s:cyan)
call s:h('DraculaCyanItalic', s:cyan, s:none, [s:attrs.italic])

call s:h('DraculaGreen', s:green)
call s:h('DraculaGreenBold', s:green, s:none, [s:attrs.bold])
call s:h('DraculaGreenItalic', s:green, s:none, [s:attrs.italic])
call s:h('DraculaGreenItalicUnderline', s:green, s:none, [s:attrs.italic, s:attrs.underline])

call s:h('DraculaOrange', s:orange)
call s:h('DraculaOrangeBold', s:orange, s:none, [s:attrs.bold])
call s:h('DraculaOrangeItalic', s:orange, s:none, [s:attrs.italic])
call s:h('DraculaOrangeBoldItalic', s:orange, s:none, [s:attrs.bold, s:attrs.italic])
call s:h('DraculaOrangeInverse', s:bg, s:orange)

call s:h('DraculaPink', s:pink)
call s:h('DraculaPinkItalic', s:pink, s:none, [s:attrs.italic])

call s:h('DraculaPurple', s:purple)
call s:h('DraculaPurpleBold', s:purple, s:none, [s:attrs.bold])
call s:h('DraculaPurpleItalic', s:purple, s:none, [s:attrs.italic])

call s:h('DraculaRed', s:red)
call s:h('DraculaRedInverse', s:fg, s:red)

call s:h('DraculaYellow', s:yellow)
call s:h('DraculaYellowItalic', s:yellow, s:none, [s:attrs.italic])

call s:h('DraculaError', s:red, s:none, [], s:red)

call s:h('DraculaErrorLine', s:none, s:none, [s:attrs.undercurl], s:red)
call s:h('DraculaWarnLine', s:none, s:none, [s:attrs.undercurl], s:orange)
call s:h('DraculaInfoLine', s:none, s:none, [s:attrs.undercurl], s:cyan)

call s:h('DraculaTodo', s:cyan, s:none, [s:attrs.bold, s:attrs.inverse])
call s:h('DraculaSearch', s:green, s:none, [s:attrs.inverse])
call s:h('DraculaBoundary', s:comment, s:bgdark)
call s:h('DraculaLink', s:cyan, s:none, [s:attrs.underline])

call s:h('DraculaDiffChange', s:orange, s:none)
call s:h('DraculaDiffText', s:bg, s:orange)
call s:h('DraculaDiffDelete', s:red, s:bgdark)

" }}}2

" }}}



" Linking *Vim-Groups to SHRAKULA-Groups: {{{

set background=dark

" base settings {{{
" Required as some plugins will overwrite

"     call s:h('Normal', s:fg, g:dracula_colorterm || has('gui_running') ? s:bg : s:none )
" use true dark for general display
call s:h('Normal', s:better_fg, g:dracula_colorterm || has('gui_running') ? s:better_bg : s:none )
" a much simpler command without the checks from above and setting only for gui
"     highlight Normal gui=NONE guifg=#ede3f7 guibg=#000000


call s:h('StatusLine', s:none, s:bglighter, [s:attrs.bold])
call s:h('StatusLineNC', s:none, s:bglight)
call s:h('StatusLineTerm', s:none, s:bglighter, [s:attrs.bold])
call s:h('StatusLineTermNC', s:none, s:bglight)

call s:h('WildMenu', s:bg, s:purple, [s:attrs.bold])


" cursor-line {{{
" SYNOPSIS:
"     The entire line that the cursor is currently on

"   call s:h('CursorLine', s:none, s:subtle)

" need to clear out the CursorLine settings from colorscheme |default|, which
" is automatically loaded when starting *Vim with |$ vim|, which could,
" however, be circumvented by running |$ vim -u ~/.vimrc |, which will
" exclusively load the specified vimrc file, not the default vimrcs
"     highlight clear CursorLine
"     call s:h('CursorLine', s:better_fg, s:better_bg, [s:attrs.underline])
highlight CursorLine gui=underline cterm=underline guibg=#000000 ctermbg=0


augroup InsCursor
    autocmd!

"   disable cursorline when entering I_Mode
    autocmd InsertEnter * highlight CursorLine gui=NONE cterm=NONE
"   reenable cursorline when leaving I_Mode
    autocmd InsertLeave * highlight CursorLine gui=underline cterm=underline
augroup END
" }}}

" status-line {{{
" normally emulate other display
highlight normalStatusLine gui=NONE cterm=NONE guibg=#000000 guifg=#ede3f7 ctermbg=0 ctermfg=255

highlight! link StatusLine normalStatusLine

highlight StatusLineNC gui=NONE guifg=#9779a7 guibg=#000000
" }}}

" }}}

" ColorColumn {{{
" SYNOPSIS:
"     the columns to always be highlighted (for horizontal cursor position
"     orientation)

highlight! link ColorColumn  DraculaBgDark
set colorcolumn=""
" }}}

" CursorColumn {{{
" SYNOPSIS:
"     the indicator at the current horizontal cursor position on every row if
"     |cursorcolumn| is enabled
highlight clear CursorColumn

" a simple inversion
highlight CursorColumn gui=reverse guifg=fg guibg=bg


" the cursorcolumn resembles more of a distraction and is thus disabled by
" default
set nocursorcolumn
" }}}


" Cursor {{{
" SYNOPSIS:
"     the cursor (caret) itself
" WARNING:
"     NOT visible under stock tmux, where a static coloring is shown,
"     disobeying the highlighting set here; run outside tmux to visualize the
"     settings here

highlight clear Cursor


" set to color of the text currently on display
"     NOTE: this is the same setting for |CursorLine| without the underlining,
"     a lazy alternative is thus:
"         ->  highlight! link Cursor CursorLine
highlight Cursor gui=NONE cterm=NONE guibg=fg guifg=bg
" }}}


" CursorLineNr {{{
" SYNOPSIS:
"     the gutter showing line number of the current line

"       highlight! link CursorLineNr DraculaYellow
highlight CursorLineNr gui=NONE guifg=#ede3f7 guibg=#000000
" }}}

" create the illusion that the tilde's are gone
highlight EndOfBuffer gui=NONE cterm=NONE guibg=#000000 guifg=#000000


hi! link DiffAdd      DraculaGreen
hi! link DiffAdded    DiffAdd
hi! link DiffChange   DraculaDiffChange
hi! link DiffDelete   DraculaDiffDelete
hi! link DiffRemoved  DiffDelete
hi! link DiffText     DraculaDiffText

hi! link Directory    DraculaPurpleBold
hi! link ErrorMsg     DraculaRedInverse


hi! link FoldColumn   DraculaSubtle

" indicating a fold
"     highlight clear Folded
hi! link Folded       DraculaBoundary
highlight Folded gui=NONE guifg=#9779a7 guibg=#000000


hi! link IncSearch    DraculaOrangeInverse

" the gutter showing line numbers of lines that are NOT the current line
"     highlight clear LineNr
call s:h('LineNr', s:comment)
highlight LineNr gui=NONE guifg=#635769 guibg=#000000

hi! link MoreMsg      DraculaFgBold
hi! link NonText      DraculaSubtle

hi! link Pmenu        DraculaBgDark
hi! link PmenuSbar    DraculaBgDark
hi! link PmenuSel     DraculaSelection
hi! link PmenuThumb   DraculaSelection

hi! link Question     DraculaFgBold
hi! link Search       DraculaSearch
call s:h('SignColumn', s:comment)

hi! link TabLine      DraculaBoundary
hi! link TabLineFill  DraculaBgDarker
hi! link TabLineSel   Normal

hi! link Title        DraculaGreenBold
hi! link VertSplit    DraculaBoundary
highlight VertSplit gui=NONE guibg=#000000 guifg=#635769

hi! link Visual       DraculaSelection
hi! link VisualNOS    Visual

hi! link WarningMsg   DraculaOrangeInverse



" lightline {{{
" close target accessible with single-char key
hi! EasyMotionTarget ctermbg=16 ctermfg=219
            \ gui=none guibg=#000000 guifg=#ffafff

" chars not used to display keys are shaded in this color
hi! EasyMotionShade  ctermbg=16 ctermfg=239
            \ gui=none guibg=#000000 guifg=#4e4e4e


" the first char for far-away targets accessible with two-char keys
hi! EasyMotionTarget2First ctermbg=16 ctermfg=117
            \ gui=none guibg=#000000 guifg=#87d7ff

" the second char for far-away targets accessible with two-char keys
hi! EasyMotionTarget2Second ctermbg=16 ctermfg=67
            \ gui=none guibg=#000000 guifg=#5f87af


" when performing easy-motion specific searching
hi! EasyMotionIncSearch ctermbg=141 ctermfg=52
            \ gui=none guibg=#af87ff guifg=#5f0000

hi! EasyMotionMoveHL ctermbg=1 ctermfg=16
            \ gui=none guibg=#800000 guifg=#000000
" }}}
" }}}


" Syntax: {{{
" use SHRAKULA colors for syntax coloring

" Required as some plugins will overwrite
call s:h('MatchParen', s:green, s:none, [s:attrs.underline])
call s:h('Conceal', s:cyan, s:none)

" Neovim uses SpecialKey for escape characters only. Vim uses it for that, plus whitespace.
if has('nvim')
  hi! link SpecialKey DraculaRed
  hi! link LspDiagnosticsUnderline DraculaFgUnderline
  hi! link LspDiagnosticsInformation DraculaCyan
  hi! link LspDiagnosticsHint DraculaCyan
  hi! link LspDiagnosticsError DraculaError
  hi! link LspDiagnosticsWarning DraculaOrange
  hi! link LspDiagnosticsUnderlineError DraculaErrorLine
  hi! link LspDiagnosticsUnderlineHint DraculaInfoLine
  hi! link LspDiagnosticsUnderlineInformation DraculaInfoLine
  hi! link LspDiagnosticsUnderlineWarning DraculaWarnLine
else
  hi! link SpecialKey DraculaSubtle
endif


"     hi! link Comment DraculaComment
" Comment lines should imitate the inactive line gutter, only slightly lighter
highlight Comment gui=NONE guifg=#897397 guibg=#000000


hi! link Underlined DraculaFgUnderline
hi! link Todo DraculaTodo

hi! link Error DraculaError
hi! link SpellBad DraculaErrorLine
hi! link SpellLocal DraculaWarnLine
hi! link SpellCap DraculaInfoLine
hi! link SpellRare DraculaInfoLine

hi! link Constant DraculaPurple
hi! link String DraculaYellow
hi! link Character DraculaPink
hi! link Number Constant
hi! link Boolean Constant
hi! link Float Constant

hi! link Identifier DraculaFg
hi! link Function DraculaGreen

hi! link Statement DraculaPink
hi! link Conditional DraculaPink
hi! link Repeat DraculaPink
hi! link Label DraculaPink
hi! link Operator DraculaPink
hi! link Keyword DraculaPink
hi! link Exception DraculaPink

hi! link PreProc DraculaPink
hi! link Include DraculaPink
hi! link Define DraculaPink
hi! link Macro DraculaPink
hi! link PreCondit DraculaPink
hi! link StorageClass DraculaPink
hi! link Structure DraculaPink
hi! link Typedef DraculaPink

hi! link Type DraculaCyanItalic

hi! link Delimiter DraculaFg

hi! link Special DraculaPink
hi! link SpecialComment DraculaCyanItalic
hi! link Tag DraculaCyan
hi! link helpHyperTextJump DraculaLink
hi! link helpCommand DraculaPurple
hi! link helpExample DraculaGreen
hi! link helpBacktick Special

"}}}

" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0 et:
