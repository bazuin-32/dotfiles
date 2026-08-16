{ ... }: {
  home-manager.users.ameen.wayland.windowManager.hyprland.settings = {
    monitor = [
      {
        output = "eDP-1";
        mode = "1920x1080@60";
        position = "0x0";
        scale = 1;
      }
      {
        output = "DP-3";
	mode = "1920x1080@60";
	position = "-1920x0";
	scale = 1;
      }
    ];

    workspace_rule = [
      {
        workspace = "1";
        monitor = "DP-3";
      }
      {
        workspace = "2";
        monitor = "DP-3";
      }
      {
        workspace = "3";
        monitor = "DP-3";
      }
      {
        workspace = "4";
        monitor = "DP-3";
      }
      {
        workspace = "5";
        monitor = "DP-3";
      }
      {
        workspace = "6";
        monitor = "eDP-1";
      }
      {
        workspace = "7";
        monitor = "eDP-1";
      }
      {
        workspace = "8";
        monitor = "eDP-1";
      }
      {
        workspace = "9";
        monitor = "eDP-1";
      }
      {
        workspace = "10";
        monitor = "eDP-1";
      }
    ];
  };
}
