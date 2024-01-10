mount() {
  if [[ "${@}" == "" ]]; then
    command mount | column -tW -1 # wrap the last column (mount options)
  else
    command mount ${@}
  fi
}
