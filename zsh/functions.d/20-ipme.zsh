function ipme() {
  url='https://ip6.me/api/'
  data=$(curl "${url}" 2>/dev/null)

  v=$(cut -d ',' -f 1 <<< $data)
  addr=$(cut -d ',' -f 2 <<< $data)
  api_version=$(cut -d ',' -f 3 <<< $data)

  bold='\e[1m'
  dim='\e[2m'
  normal='\e[0m'
  echo "Your public ${bold}${v}${normal} address is: ${bold}${addr}${normal}"
  echo "${dim}Obtained from '${url}', API version ${api_version}${normal}"
}
