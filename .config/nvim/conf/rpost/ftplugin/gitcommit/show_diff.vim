augroup show_diff_staged
    autocmd!


    " unconditionally split vertically on the right
    autocmd
        \ VimEnter
        \ COMMIT_EDITMSG,TAG_EDITMSG,MERGE_MSG
        "\ split vertically on the right
        \ rightbelow vsplit


    " the commit-tag-merge Trinity {{{
    " committing {{{
    " SYNOPSIS:
    "   create one more split (now on lower-right pane)
    "
    autocmd
        \ VimEnter
        \ COMMIT_EDITMSG
        \ rightbelow split

    " SYNOPSIS:
    "   display log on current (lower-right) pane
    "
    autocmd
        \ VimEnter
        \ COMMIT_EDITMSG
        "\ MUST spawn a new shell & MUST escape spaces
        \ terminal $SHELL -c git\ log\ --all\ --oneline\ --graph

    " SYNOPSIS:
    "   switch to previous (upper-right) pane to display staged-diff
    "
    autocmd
        \ VimEnter
        \ COMMIT_EDITMSG
        "\ switch (back) to upper-right pane (was on lower-right)
        \ wincmd p
        \ |
        "\ save space by showing only 1(one!) context-line
        \ terminal $SHELL -c git\ diff\ --cached\ --unified=1
    " }}}

    " tagging {{{
    " SYNOPSIS:
    "   display log on current pane
    "
    autocmd
        \ VimEnter
        \ TAG_EDITMSG
        \ terminal $SHELL -c git\ log\ --all\ --oneline\ --graph
    " }}}

    " merging {{{
    " SYNOPSIS:
    "   display log on current pane
    "
    autocmd
        \ VimEnter
        \ MERGE_MSG
        \ terminal $SHELL -c git\ log\ --all\ --oneline\ --graph
    " }}}
    " }}}


    " MUST split this autocmd since everything following invocation of
    " terminal is consumed and no longer interpreted by Vim
    autocmd
        \ VimEnter
        \ COMMIT_EDITMSG,TAG_EDITMSG,MERGE_MSG
        "\ return to the top-left pane, by design the message editing pane
        \ wincmd t

augroup END

