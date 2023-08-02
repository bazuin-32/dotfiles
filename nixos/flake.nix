{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, hyprland, ... } @ inputs:
  let
    mkSystemConfig = device: {
      nixosConfigurations."ameen-nixos-${device}" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = { inherit inputs; };
        modules = [
          (./. + "/${device}/configuration.nix")
          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
          }
        ];
      };

      homeConfigurations."ameen@ameen-nixos-${device}" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;

        modules = [
          hyprland.homeManagerModules.default
          {
            wayland.windowManager.hyprland.enable = true;
            wayland.windowManager.hyprland.nvidiaPatches = (if device == "desktop" then true else false);
          }
        ];
      };
    };

    laptopConfig = mkSystemConfig "laptop";
    desktopConfig = mkSystemConfig "desktop";

    nixosConfigurations = laptopConfig.nixosConfigurations // desktopConfig.nixosConfigurations;
    homeConfigurations = laptopConfig.homeConfigurations // desktopConfig.homeConfigurations;
  in {
    inherit nixosConfigurations homeConfigurations;
  };
}
