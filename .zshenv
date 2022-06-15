export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export _JAVA_AWT_WM_NONREPARENTING=1
export PATH="$PATH:/usr/local/llvm/bin:/home/ameen/go/bin"
export XPLR_BOOKMARKS_FILE="$HOME/.local/share/xplr/bookmarks"

# this is only necessary on my  desktop,
# which has an nvidia gpu
if [[ $(cat /etc/hostname) != *"laptop"* ]]; then
	export WLR_NO_HARDWARE_CURSORS=1
fi
