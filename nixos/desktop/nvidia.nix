{ ... }: {
  # get nvidia drivers
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;

  # wayland nvidia
  hardware.nvidia.modesetting.enable = true;
  boot.kernelParams = [ "nvidia_drm.modeset=1" ];

  # patches for wlroots
  programs.hyprland.nvidiaPatches = true;

  environment.variables = {
    LIBSEAT_BACKEND = "logind";
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
  };
}
