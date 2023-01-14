# git aliases

alias gcps='git commit -a && git push'
alias gc='git commit -a'
alias gps='git push'
alias gpl='git pull'
alias gft='git fetch'
alias grst='git restore'
alias gwt='git worktree'
# pull all repos
alias gupd='fd -HIat d "^\.git$" ~ | grep -vE "(\.cache|\.oh-my-zsh|\.cargo|\.rofi|_deps)" | xargs -i zsh -c "cd {}/.. && echo \"\n\" && echo {} | rev | cut -d \"/\" -f 2- | rev | sed \"s#/home/ameen#~#\" && { git pull --recurse-submodules && git submodule update --recursive } & "'
