# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # hardware-configuration.nix is handled by the flake, so different versions can be used for different devices
    ./user-config.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  nix = {
    package = pkgs.nixUnstable;
    
    settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.systemd-boot.editor = false; # disable editing of kernel cmdline, to prevent root access
  boot.loader.systemd-boot.memtest86.enable = true;

  # Pick only one of the below networking options.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Denver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    # keyMap = "us";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  services.xserver = {
    enable = true;

    displayManager.lightdm = {
      enable = true;
      greeters.gtk = {
        enable = true;
        theme.name = "Adwaita-dark";
        iconTheme.name = "Adwaita-dark";
      };
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  #hardware.pulseaudio.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    gcc
    clang_16
    clang-tools_16
    cmake
    gnumake
    ninja
    brightnessctl
    pciutils
    jq
    ripgrep
    fzf
    pulseaudio # only to provide `pactl`, even though pipewire is used as the real backend
    sof-firmware
    (lib.hiPrio pkgs.procps) # needed to be able to do `uptime -p`, coreutils uptime doesnt have the `-p` flag
    killall
    cifs-utils

    # for windwatcher development. TODO: use dedicated windwatcher nix setup
    opencv
  ];

  fileSystems."/net/ameen" = {
    device = "//10.0.20.5/ameen";
    fsType = "cifs";
    options = let
      # to prevent hanging on network split, see https://nixos.wiki/wiki/Samba
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    in [ "${automount_opts}" "credentials=/etc/.cifscred-ameen" "uid=1000" "gid=100" ];
  };
  fileSystems."/net/public" = {
    device = "//10.0.20.5/public";
    fsType = "cifs";
    options = let
      # to prevent hanging on network split, see https://nixos.wiki/wiki/Samba
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    in [ "${automount_opts}" "credentials=/etc/.cifscred-ameen" "uid=1000" "gid=100" ];
  };

  # Make SysRq actually useful
  # This enables all but debugging dumps from the bitmask categories listed on https://www.kernel.org/doc/html/latest/admin-guide/sysrq.html
  # aka `0x2 | 0x4 | 0x10 | 0x20 | 0x40 | 0x80 | 0x100`
  # aka `0x1f6`
  boot.kernel.sysctl = {
    "kernel.sysrq" = 502;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };


  # List services that you want to enable:

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  #system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

