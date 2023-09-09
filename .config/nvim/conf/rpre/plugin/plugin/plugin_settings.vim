" netrw {{{
" |::E| considered easier to hit than |::e|, thus opens a friendlier split
cnoremap :E vsplit +Explore
cnoremap :e tabnew +Explore

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
