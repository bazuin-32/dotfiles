source ~/.config/xkcd.zsh
source ~/.config/paclog.zsh
neofetch

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/ameen/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
zstyle ':omz:update' mode auto      # update automatically without asking
#zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 1

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git archlinux zsh-syntax-highlighting zsh-autosuggestions zsh-completions vi-mode)

source $ZSH/oh-my-zsh.sh

# User configuration

# enable more completion capability, including personal completions
fpath=($fpath ~/.config/completions)
autoload -U compinit && compinit

# cache completions for better speed
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "~/.cache/zsh/.zcompcache"

# globbing options
setopt extendedglob
setopt GLOBSTARSHORT

# make cd keep a dir stack
setopt autopushd

# disable cd-ing to a dir given on its own with out `cd`
unsetopt auto_cd

# set nvim for editors
export EDITOR=nvim
export SUDO_EDITOR=nvim

# history optionss
export HISTFILE
export HISTSIZE=50000
export SAVEHIST=50000
setopt appendhistory
setopt hist_find_no_dups	# do not show duplicates when stepping through history
setopt hist_ignore_all_dups	# do not save duplicates to HISTFILE

# set colors for exa, see https://github.com/ogham/exa/blob/master/man/exa_colors.5.md
export EXA_COLORS="di=33;1:su=1;4:sf=1:4"

# clear unwanted aliases
unalias gp

# load redo-generated functions
source $(redo alias-file)

# this makes aliases expand when using sudo, even though they are not
# in root's shell rc files
alias sudo='sudo '

# general aliases
#alias ls='ls -lsh'
#alias l='ls -alshv'
alias ls='exa -lbghm@ --icons --git --color=always'
alias l='exa -labghm@ --all --icons --git --color=always'
alias restart-audio='systemctl restart pulseaudio.service --user'
alias ytdl='youtube-dl'
alias upgrade='yay -Syu && echo "Updating -F (file) database..." && yay -Fy'
alias diff='diff -y --color=always'
alias sctl='sudo systemctl'
alias sctlu='systemctl --user'
alias svim='sudo -e'
alias lsblk='lsblk -a --output NAME,LABEL,FSTYPE,SIZE,FSUSE%,RO,TYPE,MOUNTPOINT'
alias wrsync='rsync -Wr --no-compress --info=progress2'
alias ttq='tt -bold -quotes en -csv -theme gruvbox-dark >> ~/ttstats.csv'
alias ttp='tt -bold -csv -theme gruvbox-dark $(find /usr/local/share/texts -type f | shuf -n 1) >> ~/ttstats.csv'
alias netmnt='for dir in {ameen,public}; do sudo mount -t cifs -o cred=/home/ameen/.cifscred-ameen,uid=1000,gid=1001,vers=3.0,rw //10.0.0.5/$(echo ${dir} | sed "s/.*/\u&/") /net/${dir}; done'
alias dmesg='sudo dmesg --color=always'
alias ping='ping -O'
alias grep='grep --color=always'
alias cat='bat'

# git aliases
alias gcps='/usr/local/bin/git-commit.sh && git push'
alias gc='/usr/local/bin/git-commit.sh'
alias gps='git push'
alias gpl='git pull && echo "\n\nLatest commit:\n"; git log -1 --stat --color | cat'
alias gft='git fetch'
alias grst='git restore'
# pull all repos
alias gupd='find ~ -type d -name ".git" -prune | egrep -v "(\.cache|\.oh-my-zsh|\.cargo|\.rofi|_deps)" | xargs -i zsh -c "cd {}/.. && echo \"\n\" && echo {} | rev | cut -d \"/\" -f 2- | rev | sed \"s#/home/ameen#~#\" && git pull"'

# vpn aliases
alias vpn-start='openvpn3 session-start -c ameen-arch-laptop.ovpn'
alias vpn-restart='openvpn3 session-manage --restart -c ameen-arch-laptop.ovpn'
alias vpn-stop='openvpn3 session-manage --disconnect -c ameen-arch-laptop.ovpn'

# fzf searcher
function srch() {
    local result
    if [ "$1" != "" ]
    then
	    result="$(find "$1" | fzf)"
    else
	    result="$(find . | fzf)"
    fi

    echo "$result"
}

# fuzzy utils
function srcho() {
	local result=$(srch "$1")
	xdg-open "$result"
}

function fcd() {
	local result
	if [ "$1" != "" ]
	then
		result="$(find "$1" -type d | fzf)"
	else
		result="$(find . -type d | fzf)"
	fi

	cd "$result"
}

# command not found
function command_not_found_handler {
    local purple='\e[1;35m' bright='\e[0;1m' green='\e[1;32m' reset='\e[0m'
    printf 'zsh: command not found: %s\n' "$1"
    local entries=(
        ${(f)"$(yay -F --machinereadable -- "/usr/bin/$1")"}
    )
    if (( ${#entries[@]} ))
    then
        printf "${bright}$1${reset} may be found in the following packages:\n"
        local pkg
        for entry in "${entries[@]}"
        do
            # (repo package version file)
            local fields=(
                ${(0)entry}
            )
            if [[ "$pkg" != "${fields[2]}" ]]
            then
                printf "${purple}%s/${bright}%s ${green}%s${reset}\n" "${fields[1]}" "${fields[2]}" "${fields[3]}"
            fi
            printf '    /%s\n' "${fields[4]}"
            pkg="${fields[2]}"
        done
    fi
}

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

xkcd newest
