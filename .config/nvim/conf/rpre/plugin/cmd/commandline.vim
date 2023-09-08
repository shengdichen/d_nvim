" enable commandline completion
set wildmenu

" completion strategy: when multiple matches exist, prompt and complete until
" the longest common string
set wildmode=list:longest

" shortcut to save all
cnoremap :W wa! <Enter>

" mapping to Backspace also clears existing input at command-line
cnoremap JJ <C-U><BS>
