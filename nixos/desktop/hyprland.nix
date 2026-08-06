{ ... }: {
  home-manager.users.ameen.wayland.windowManager.hyprland.settings = {
    monitor = [
      {
        output = "HDMI-A-2";
        mode = "1920x1080@60";
        position = "0x0";
        scale = 1;
      }
      {
        output = "HDMI-A-1";
        mode = "1920x1080@60";
        position = "1920x0";
        scale = 1;
      }
      {
        output = "VGA-1";
        disabled = true;
      }
      {
        output = "Unknown-1";
        disabled = true;
      }
    ];

    workspace_rule = [
      {
        workspace = "1";
        monitor = "HDMI-A-2";
      }
      {
        workspace = "2";
        monitor = "HDMI-A-2";
      }
      {
        workspace = "3";
        monitor = "HDMI-A-2";
      }
      {
        workspace = "4";
        monitor = "HDMI-A-2";
      }
      {
        workspace = "5";
        monitor = "HDMI-A-2";
      }
      {
        workspace = "6";
        monitor = "HDMI-A-1";
      }
      {
        workspace = "7";
        monitor = "HDMI-A-1";
      }
      {
        workspace = "8";
        monitor = "HDMI-A-1";
      }
      {
        workspace = "9";
        monitor = "HDMI-A-1";
      }
      {
        workspace = "10";
        monitor = "HDMI-A-1";
      }
    ];
  };
}
