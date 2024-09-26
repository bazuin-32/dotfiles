{ config, ... }: {
  # get nvidia drivers
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics.enable = true;
  hardware.nvidia.open = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.production;

  # wayland nvidia
  hardware.nvidia.modesetting.enable = true;
  boot.kernelParams = [ "nvidia_drm.modeset=1" ];

  environment.variables = {
    LIBSEAT_BACKEND = "logind";
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
  };
}
