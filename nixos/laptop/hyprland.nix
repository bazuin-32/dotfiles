{ ... }: {
  home-manager.users.ameen.wayland.windowManager.hyprland.settings = {
    monitor = [
      {
        output = "eDP-1";
        mode = "1920x1080@60";
        position = "0x0";
        scale = 1;
      }
    ];
  };
}
