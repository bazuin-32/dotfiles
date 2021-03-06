# clear unwanted aliases
unalias gp

# load redo-generated functions
source $(redo alias-file)

# this makes aliases expand when using sudo, even though they are not
# in root's shell rc files
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
alias diff='diff -y --color=always'
alias sctl='sudo systemctl'
alias sctlu='systemctl --user'
alias svim='sudo -e'
alias lsblk='lsblk -a --output NAME,LABEL,FSTYPE,SIZE,FSUSE%,RO,TYPE,MOUNTPOINT'
alias wrsync='rsync -Wr --no-compress --info=progress2'
alias ttq='tt -bold -quotes en -csv -theme gruvbox-dark >> ~/ttstats.csv'
alias ttp='tt -bold -csv -theme gruvbox-dark $(find /usr/local/share/texts -type f | shuf -n 1) >> ~/ttstats.csv'
alias netmnt='for dir in {ameen,public}; do sudo mount -t cifs -o cred=/home/ameen/.cifscred-ameen,uid=1000,gid=1001,vers=3.0,rw //10.0.20.5/$(echo ${dir} | sed "s/.*/\u&/") /net/${dir}; done'
alias dmesg='sudo dmesg --color=always'
alias ping='ping -O'
alias grep='grep --color=always'
alias cat='bat'
alias less='bat --paging=always'

# git aliases
alias gcps='git commit -a && git push'
alias gc='git commit -a'
alias gps='git push'
alias gpl='git pull'
alias gft='git fetch'
alias grst='git restore'
# pull all repos
alias gupd='fd -HIat d "^\.git$" ~ | egrep -v "(\.cache|\.oh-my-zsh|\.cargo|\.rofi|_deps)" | xargs -i zsh -c "cd {}/.. && echo \"\n\" && echo {} | rev | cut -d \"/\" -f 2- | rev | sed \"s#/home/ameen#~#\" && { git pull --recurse-submodules && git submodule update --recursive } & "'

# vpn aliases
alias vpn-start='openvpn3 session-start -c ameen-arch-laptop.ovpn'
alias vpn-restart='openvpn3 session-manage --restart -c ameen-arch-laptop.ovpn'
alias vpn-stop='openvpn3 session-manage --disconnect -c ameen-arch-laptop.ovpn'
