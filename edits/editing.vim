set undolevels=1000

set textwidth=79

set autoindent

" spaces instead of tabs
set expandtab smarttab shiftround

" 4 characters per tab
set tabstop=4 softtabstop=4 shiftwidth=4

" use system clipboard
set clipboard+=unnamedplus

" white-spaces removal {{{
" remove trailing white-spaces without cursor displacement
function! <SID>RemoveTrailingSpaces()
    " save current cursor position
    let l = line(".")
    let c = col(".")

    " the core of trailing white-space removal
    %s/\s\+$//e

    call cursor(l, c)
endfun

" always remove trailing workspaces
autocmd BufWritePre * :call <SID>RemoveTrailingSpaces()


" for type-specific removal
"       autocmd FileType c,cpp,java autocmd BufWritePre * :call <SID>RemoveTrailingSpaces()

" alternatively, actively perform removal with:
"       nnoremap <leader><leader>ws :call <SID>RemoveTrailingSpaces()


" Note that leading spaces can be removed in a similar fashion:
"       :%s/^\s\+//e
" }}}

