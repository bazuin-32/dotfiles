{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprcursor-phinger = {
      url = "github:jappie3/hyprcursor-phinger";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cassowary = {
      url = "github:AtaraxiaSjel/cassowary";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    astal = {
      url = "github:Aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    globalprotect-openconnect = {
      url = "github:yuezk/GlobalProtect-openconnect/3c49eab0c885d546b0001fa7c85b1daf0f4d4ac2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    globalprotect-tray-src = {
      url = "github:brycewalkerdev/globalprotect-tray-app";
      flake = false;
    };
  };

  outputs = { nixpkgs, home-manager, hyprland, ... } @ inputs:
  let
    mkSystemConfig = device: {
      nixosConfigurations."ameen-nixos-${device}" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = { inherit inputs; };
        modules = [
          (./. + "/${device}/configuration.nix")
          ./applications/configuration.nix
          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            #home-manager.useGlobalPkgs = true;
          }

	  ({ config, lib, options, pkgs, ... }:
          let
            gpoc =
              inputs.globalprotect-openconnect.packages.${pkgs.system}.default;

            tray = pkgs.callPackage ./packages/globalprotect-tray.nix {
              src = inputs.globalprotect-tray-src;
              inherit gpoc;
            };
          in
          {
            environment.systemPackages = [
              gpoc
              tray
            ];

            security.polkit = {
              enable = true;
            } // lib.optionalAttrs (options.security.polkit ? enablePkexecWrapper) {
              enablePkexecWrapper = true;
            };

            services.ayatana-indicators.enable = lib.mkDefault true;

            environment.etc."polkit-1/actions/io.github.brycewalkerdev.globalprotect-tray-app.policy".source =
              "${tray}/share/polkit-1/actions/io.github.brycewalkerdev.globalprotect-tray-app.policy";
          })

        ];
      };

      homeConfigurations."ameen@ameen-nixos-${device}" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;

        modules = [
          hyprland.homeManagerModules.default
          {
            wayland.windowManager.hyprland.enable = true;
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
