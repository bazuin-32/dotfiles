{ config, pkgs, ... }:

{
  users.users.ameen = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      firefox
      thunderbird
      onlyoffice-bin
      mpv
    ];
  };
  home-manager.useUserPackages = true;
  home-manager.users.ameen = { pkgs, ... }: {
    home.stateVersion = "23.05";
    nixpkgs.config.allowUnfree = true;
    programs.home-manager.enable = true;

    home.packages = with pkgs; [
      vscode
      foot
    ];
    programs.zsh.enable = true;

    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
    };

    programs.git = {
      enable = true;
      userName = "bazuin-32";
      userEmail = "ameenpiano@gmail.com";
      extraConfig.push.autoSetupRemote = true;
    };
    programs.neovim = {
      enable = true;
    };
  };
}
