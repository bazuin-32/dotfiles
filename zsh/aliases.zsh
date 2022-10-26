# clear unwanted aliases
unalias gp

# source all the alias files in the subdir
for file in ./aliases/*.zsh; do
  . ${file}
done
