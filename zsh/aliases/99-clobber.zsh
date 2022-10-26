##### 'clobbering' aliases #####
# things that are unlikely to work on random machines
# because they require programs that may not exist on them
# (e.g. `exa`)

alias ls='exa -lbghm@ --icons --git --color=always'
alias l='exa -labghm@ --all --icons --git --color=always'
