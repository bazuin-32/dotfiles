# this makes aliases expand when using sudo, even though they are not
# in root's shell rc files
# e.g. `sudo ls` will expand `ls` so that the command becomes `sudo exa ...`
# without this, `ls` would not be expanded and `/usr/bin/ls` would be executed instead
alias sudo='sudo '
