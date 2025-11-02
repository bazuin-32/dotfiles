{ pkgs, ... }: {
  services.openvpn.servers.home = {
    config = ''
      config /home/ameen/ameen-nixos-laptop.ovpn
      script-security 2
      up /etc/openvpn/update-resolv-conf
      down /etc/openvpn/update-resolv-conf
      down-pre
    '';
    autoStart = false;
  };

# make sure that dns gets updated when connecting to vpn
  environment.etc.openvpn.source = "${pkgs.update-resolv-conf}/libexec/openvpn";

  # see https://nixos.wiki/wiki/OpenVPN
  # I have commented this out because it makes mounting the fs
  # trigger the vpn automatically, which is not always wanted (i.e. when at home)
  # fileSystems."/net/ameen".options = [ "x-systemd.requires=openvpn-home.service" ];
  # fileSystems."/net/public".options = [ "x-systemd.requires=openvpn-home.service" ];
}
