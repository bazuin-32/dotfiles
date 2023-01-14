# source all the files in the subdir
script_path="$(readlink -f -- "${0}")"
script_dir="$(dirname -- "${script_path}")"
for file in ${script_dir}/functions.d/*.zsh; do
  . ${file}
done
