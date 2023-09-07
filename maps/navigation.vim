" faster scrolling
nnoremap J 4j
nnoremap K 4k
vnoremap J 4j
vnoremap K 4k

" the true beginning (end) of lines, ignoring all leading (trailing) spaces
nnoremap H g^
nnoremap L g_
vnoremap H g^
vnoremap L g_

" for longer sentences in prose-form, allows navigate with reference to visual
" lines instead of a whole sentence (defined as between two <CR>s).
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

nnoremap 0 g0
nnoremap $ g$
vnoremap 0 g0
vnoremap $ g$

" line-wise scrolling
nnoremap <Up> <C-Y>
nnoremap <Down> <C-E>
vnoremap <Up> <C-Y>
vnoremap <Down> <C-E>

" scrolling by half a page
nnoremap <PageUp> <C-U>
nnoremap <PageDown> <C-D>
vnoremap <PageUp> <C-U>
vnoremap <PageDown> <C-D>

" manually set folding
set foldmethod=indent
