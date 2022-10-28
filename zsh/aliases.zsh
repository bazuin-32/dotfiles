# clear unwanted aliases
unalias gp

# source all the alias files in the subdir
script_path="$(readlink -f -- "${0}")"
script_dir="$(dirname -- "${script_path}")"
for file in ${script_dir}/aliases.d/*.zsh; do
  . ${file}
done
