{ ... }: {
  home-manager.users.ameen.wayland.windowManager.hyprland.settings = {
    monitor = [
      "eDP-1, 1920x1080@60, 0x0, 1"
    ];

    workspace = [
      "eDP-1, 1" # starting workspace
    ];
  };
}
