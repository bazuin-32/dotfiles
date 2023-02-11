# things purely for convenience

alias diff='diff --color=auto'
alias lsblk='lsblk -a --output NAME,LABEL,FSTYPE,SIZE,FSUSE%,RO,TYPE,MOUNTPOINTS'
alias wrsync='rsync -Wr --no-compress --info=progress2'
# shellcheck disable=SC2154
alias netmnt='for dir in {ameen,public}; do sudo mount -t cifs -o cred=/home/ameen/.cifscred-ameen,uid=1000,gid=1001,vers=3.0,rw //10.0.20.5/$(echo ${dir} | sed "s/.*/\u&/") /net/${dir}; done'
alias ping='ping -O'
alias grep='grep --color=auto'
alias hgrep='history | grep'
alias ssh='TERM=xterm-256color ssh'
