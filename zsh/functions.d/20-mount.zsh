mount() {
  if [[ "${@}" == "" ]]; then
    command mount | column -t
  else
    command mount ${@}
  fi
}
