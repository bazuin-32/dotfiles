{ pkgs, inputs, ... }: {
  nixpkgs.overlays = [
    (final: prev: {
      cassowary-py = inputs.cassowary.packages.${pkgs.system}.cassowary;
     })
  ];

  home-manager.users.ameen = {
    home.packages = with pkgs; [
      cassowary-py
    ];

    xdg.desktopEntries.cassowary-fullrdp = {
      name = "Cassowary Full RDP Session";
      genericName = "Cassowary Remote Application";
      categories = [ "Network" ];
      exec = "cassowary -f %U";
      terminal = false;
    };
  };
}
