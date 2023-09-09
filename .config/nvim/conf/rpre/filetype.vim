" NOTE:
"   1. view current filetype:
"       :set filetype?
"   2. (re)detect filetype:
"       :filetype detect

autocmd BufNewFile,BufRead known_hosts setfiletype ssh_known_hosts
