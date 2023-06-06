{ ... }: {
  imports = [
    ./hostname.nix
    ./hardware-configuration.nix
    ./nvidia.nix
  ];
}
