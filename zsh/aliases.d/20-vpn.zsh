# vpn aliases

alias vpn-start='openvpn3 session-start -c home'
alias vpn-restart='openvpn3 session-manage --restart -c home'
alias vpn-stop='openvpn3 session-manage --disconnect -c home'
alias vpn-stats='openvpn3 sessions-list && openvpn3 session-stats -c home'
