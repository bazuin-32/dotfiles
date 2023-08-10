{ ... }: {
  services.openvpn.servers.home = {
    config = '' config /home/ameen/ameen-nixos-laptop.ovpn '';
    autoStart = false;
  };

  # see https://nixos.wiki/wiki/OpenVPN
  # I have commented this out because it makes mounting the fs
  # trigger the vpn automatically, which is not always wanted (i.e. when at home)
  # fileSystems."/net/ameen".options = [ "x-systemd.requires=openvpn-home.service" ];
  # fileSystems."/net/public".options = [ "x-systemd.requires=openvpn-home.service" ];
}
