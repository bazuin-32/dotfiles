{ ... }: {
  home-manager.users.ameen.wayland.windowManager.hyprland.settings = {
    monitor = [
      "HDMI-A-2, 1920x1080@60, 0x0, 1"
      "HDMI-A-1, 1920x1080@60, 1920x0, 1"
      "VGA-1, disable"
      "Unknown-1, disable"
    ];

    workspace = [
      # starting workspaces
      "HDMI-A-2, 1"
      "HDMI-A-1, 6"

      # force workspaces to always be on specific monitors
      "1, monitor:HDMI-A-2"
      "2, monitor:HDMI-A-2"
      "3, monitor:HDMI-A-2"
      "4, monitor:HDMI-A-2"
      "5, monitor:HDMI-A-2"
      "6, monitor:HDMI-A-1"
      "7, monitor:HDMI-A-1"
      "8, monitor:HDMI-A-1"
      "9, monitor:HDMI-A-1"
      "10, monitor:HDMI-A-1"
    ];
  };
}
