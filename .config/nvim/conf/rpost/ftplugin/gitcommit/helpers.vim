" display status-line by default to avoid bad aliasing
setlocal laststatus=2

" enable spell-checking by default
"   NOTE: use setlocal to only involve the message editing buffer
setlocal spell spelllang=en

cnoremap wq w <bar> qa
