# clear unwanted aliases
unalias gp

# this makes aliases expand when using sudo, even though they are not
# in root's shell rc files
# e.g. `sudo ls` will expand `ls` so that the command becomes `sudo exa ...`
# without this, `ls` would not be expanded and `/usr/bin/ls` would be executed instead
alias sudo='sudo '

# file/dir operation aliases
alias cp='cp -v'
alias mv='mv -v'
alias rm='rm -v'
alias mkdir='mkdir -pv'
alias rmdir='rmdir -v'

# general aliases
#alias ls='ls -lsh'
#alias l='ls -alshv'
alias ls='exa -lbghm@ --icons --git --color=always'
alias l='exa -labghm@ --all --icons --git --color=always'
alias restart-audio='systemctl restart pulseaudio.service --user'
alias ytdl='youtube-dl'
alias upgrade='yay -Syu && yay -Fy'
alias diff='diff --color=auto'
alias sctl='sudo systemctl'
alias sctlu='systemctl --user'
alias svim='sudo -e'
alias lsblk='lsblk -a --output NAME,LABEL,FSTYPE,SIZE,FSUSE%,RO,TYPE,MOUNTPOINTS'
alias wrsync='rsync -Wr --no-compress --info=progress2'
alias ttq='tt -bold -quotes en -csv -theme gruvbox-dark >> ~/ttstats.csv'
alias ttp='tt -bold -csv -theme gruvbox-dark $(find /usr/local/share/texts -type f | shuf -n 1) >> ~/ttstats.csv'
alias netmnt='for dir in {ameen,public}; do sudo mount -t cifs -o cred=/home/ameen/.cifscred-ameen,uid=1000,gid=1001,vers=3.0,rw //10.0.20.5/$(echo ${dir} | sed "s/.*/\u&/") /net/${dir}; done'
alias dmesg='sudo dmesg --color=always'
alias ping='ping -O'
alias grep='grep --color=auto'
alias hgrep='history | grep'

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

# vpn aliases
alias vpn-start='openvpn3 session-start -c home'
alias vpn-restart='openvpn3 session-manage --restart -c home'
alias vpn-stop='openvpn3 session-manage --disconnect -c home'
alias vpn-stats='openvpn3 sessions-list && openvpn3 session-stats -c home'
