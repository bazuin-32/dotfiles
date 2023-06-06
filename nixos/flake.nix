{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { nixpkgs, home-manager, hyprland, ... }:
  let
    mkSystemConfig = device: {
      nixosConfigurations."ameen-nixos-${device}" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          (./. + "/${device}/hardware-configuration.nix")
          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
          }

          hyprland.nixosModules.default
          {
            programs.hyprland.enable = true;
          }
        ];
      };

      homeConfigurations."ameen@ameen-nixos-${device}" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;

        modules = [
          hyprland.homeManagerModules.default
          {wayland.windowManager.hyprland.enable = true;}
        ];
      };
    };
  in {
    inherit (mkSystemConfig "laptop") nixosConfigurations homeConfigurations;
  };
}
