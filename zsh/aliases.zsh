# clear unwanted aliases
unalias gp

# source all the alias files in the subdir
for file in ${0:A:h}/aliases/*.zsh; do
  . ${file}
done
