{ ... }: {
  imports = [
    ./hostname.nix
    ./hardware-configuration.nix

    ./battery.nix
    ./fonts.nix
    ./fingerprint.nix
  ];
}
