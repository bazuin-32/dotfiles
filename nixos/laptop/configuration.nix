{ ... }: {
  imports = [
    ./hostname.nix
    ./hardware-configuration.nix
    ./fonts.nix
    ./fingerprint.nix
  ];
}
