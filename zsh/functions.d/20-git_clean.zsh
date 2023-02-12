function git-clean() {
  branches=()
  max_branch_name_len=0

  git fetch -p && \
    for branch in $(git for-each-ref --format '%(refname) %(upstream:track)' refs/heads | awk '$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}'); do
      branches+=("${branch}")

      if [[ ${#branch} -gt ${max_branch_name_len} ]]; then
        max_branch_name_len=${#branch}
      fi
    done

  if [[ ${#branches[@]} -eq 0 ]]; then
    echo "All local branches exist remotely, no work to do."
    return
  fi

  echo "The following local branches do not exist remotely and will be deleted:"
  for branch in "${branches[@]}"; do
    branch_info=$(git branch -vvl --color=always "${branch}")

    # shellcheck disable=SC2183,SC2004
    padding=$( printf '%*s' $(( ${#branch} - ${max_branch_name_len} )) )

    # make the branch name bold and add padding to it
    bold='\\033[1m'
    light='\\033[2m'
    blue='\\033[34m'
    normal='\\033[0m'
    regex='^\s*(\S+)\s(\S+)\s(\[.+\])\s(.*)'
    replace="${bold}\\1${normal}${padding} ${blue}\\2${normal} ${light}\\4${normal}"
    branch_info=$(sed -E "s/${regex}/${replace}/" <<< "${branch_info}")


    echo " - ${branch_info}"
  done

  printf "\nAre you sure you want to continue? [y/N] "
  read -r response
  echo ''

  if [[ "${response}" == "y" || "${response}" == "Y" ]]; then
    for branch in "${branches[@]}"; do
      git branch -d "${branch}"

      # shellcheck disable=SC2181
      if [[ $? -ne 0 ]]; then
        echo -ne "\033[1;31mError deleting branch \`${branch}\`.\033[0m Do you want to try force deleting it? [y/N] "
        read -r response

        if [[ "${response}" == "y" || "${response}" == "Y" ]]; then
          git branch -D "${branch}"
        else
          printf "Not deleting.\n\n"
        fi
      fi
    done
  else
    echo "No branches deleted."
  fi
}
