{ config, pkgs, ... }:

{
  programs.dconf.enable = true; # requred for gtk themes
  programs.zsh.enable = true; # required to be able to set user's default shell, even though zsh is configured in home-manager
  security.pam.services.swaylock = {}; # without this it is impossible to unlock

  users.users.ameen = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  environment.pathsToLink = [ "/share/zsh" ]; # for zsh completions, see https://rycee.gitlab.io/home-manager/options.html#opt-programs.zsh.enableCompletion
  home-manager.useUserPackages = true;
  home-manager.users.ameen = { config, pkgs, ... }: {
    home.stateVersion = "23.05";
    nixpkgs.config.allowUnfree = true;
    programs.home-manager.enable = true;

    home.packages = with pkgs; [
      onlyoffice-bin
      mpv
      neofetch
      eww-wayland
      swaybg
      swaylock-effects
      swayidle
      grim
      slurp
      imagemagick
      rofi-wayland
      wl-clipboard
      cantarell-fonts
      meslo-lgs-nf
      nerdfonts
      jdk # required for sonarlint vscode extension
      socat
      xplr
      nix-index
      zip
      unzip
      unrar
      file
      fd
      nomacs
      wineWowPackages.wayland
      yt-dlp
    ];

    fonts.fontconfig.enable = true;
    
    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      enableSyntaxHighlighting = true;
      enableVteIntegration = true;
      autocd = false;

      # dotDir = "..."; # maybe add this?

      history = {
        extended = true; # save timestamps
        ignoreSpace = true;
        path = "$HOME/.local/share/zsh/zsh_history";
        save = 50000;
        size = 50000;
      };

      initExtra = ''
        setopt extendedglob
        setopt globstarshort
        setopt autopushd # make cd keep a dir stack

        . ~/.config/zsh/functions.zsh

        neofetch
      '';
      envExtra = ''
        # set colors for exa, see https://github.com/ogham/exa/blob/master/man/exa_colors.5.md
        export EXA_COLORS="di=33;1:su=1;4:sf=1:4"
      '';

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "sudo"
        ];
        extraConfig = ''
          # cache completions for better speed
          zstyle ':completion:*' use-cache on
          zstyle ':completion:*' cache-path "$HOME/.cache/zsh/.zcompcache"
        '';
      };

      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = pkgs.lib.cleanSource ../zsh;
          file = "p10k.zsh";
        }
      ];

      shellAliases = {
        sudo = "sudo "; # makes aliases that follow `sudo` be expanded

        cp = "cp -v";
        mv = "mv -v";
        rm = "rm -v";
        mkdir = "mkdir -pv";
        rmdir = "rmdir -v";
        ls = "exa -lbghm@ --icons --git --color=always";
        l = "exa -labghm@ --all --icons --git --color=always";
        chmod = "chmod -v";
        chown = "chown -v";
        chattr = "chattr -v";
        ln = "ln -v";

        # git
        gcps = "git commit -a && git push";
        gc = "git commit -a";
        gps = "git push";
        gpl = "git pull";
        gft = "git fetch";
        grst = "git restore";
        gwt = "git worktree";

        # sysadmin tools
        sctl = "sudo systemctl";
        sctlu = "systemctl --user";
        svim = "sudo -e";
        dmesg = "sudo dmesg --color=always";
        killall = "killall -v";
        umount = "umount -v";

        # vpn
        vpn-start = "openvpn3 session-start -c home";
        vpn-restart = "openvpn3 session-manage --restart -c home";
        vpn-stop = "openvpn3 session-manage --disconnect -c home";
        vpn-stats = "openvpn3 sessions-list && openvpn3 session-stats -c home";

        diff = "diff --color=auto";
        lsblk = "lsblk -a --output 'NAME,LABEL,FSTYPE,SIZE,FSUSE%,RO,TYPE,MOUNTPOINTS'";
        wrsync = "rsync -Wr --no-compress --info=progress2";

        ping = "ping -O";
        grep = "grep --color=auto";
        hgrep = "history | grep";
        ssh = "TERM=xterm-256color ssh";
      };
    };
    
    programs.btop = {
      enable = true;
      settings = {
        color_theme = "gruvbox_material_dark";
        presets = "cpu:1:default,proc:0:default cpu:0:default,mem:0:default,net:0:default cpu:0:block,net:0:tty";
        vim_keys = true;
        shown_boxes = "cpu mem net proc";
        update_ms = 1000;
        proc_sorting = "memory";
        proc_tree = true;
        proc_per_core = false;
        cpu_graph_lower = "iowait";
        clock_format = "%X";
        disks_filter = "";
      };
    };

    programs.foot = {
      enable = true;
      settings = {
        # `main.font` set in device-specifc config files
        cursor = {
          style = "beam";
          blink = true;
        };
        colors = {
          background = "282828";
          foreground = "ebdbb8";

          # normal colors
          regular0 = "1d1f21";
          regular1 = "cc241d";
          regular2 = "98971a";
          regular3 = "d79921";
          regular4 = "458588";
          regular5 = "b16286";
          regular6 = "689d6a";
          regular7 = "ebdbb8";
          
          # bold/bright colors
          bright0 = "666666";
          bright1 = "fb4934";
          bright2 = "b8bb26";
          bright3 = "fabd2f";
          bright4 = "83a598";
          bright5 = "d3869b";
          bright6 = "8ec07c";
          bright7 = "ebdbb2";
          
          # dim white, I don't like the autodetermined value for it
          dim7 = "bbab88";
        };
      };
    };

    programs.exa.enable = true;

    programs.bat = {
      enable = true;
      config = {
        theme = "gruvbox-dark";
      };
    };

    programs.git = {
      enable = true;
      userName = "bazuin-32";
      userEmail = "ameenpiano@gmail.com";
      extraConfig.push.autoSetupRemote = true;
    };
    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };

    programs.tealdeer = {
      enable = true;
    };



    gtk = {
      enable = true;
      font = {
        name = "Cantarell";
        size = 12;
      };
      theme.name = "Adwaita-dark";
      iconTheme.name = "Adwaita-dark";
    };

    programs.thunderbird = {
      enable = true;
      profiles.default = {
        isDefault = true;
      };
    };

    programs.firefox = {
      enable = true;
      package = pkgs.firefox-devedition;
      profiles.default = {
        name = "dev-edition-default";
        isDefault = true;
        
        search.default = "Google";
        search.force = true;
        search.engines = {
          "Nix Packages" = {
            urls = [{ template = "https://search.nixos.org/packages?type=packages&channel=unstable&query={searchTerms}"; }];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };

          "NixOS Wiki" = {
            urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
            iconUpdateURL = "https://nixos.wiki/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = [ "@nw" ];
          };

          "NixOS Options" = {
            urls = [{ template = "https://search.nixos.org/options?type=options&channel=unstable&query={searchTerms}"; }];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@no" ];
          };

          "Bing".metaData.hidden = true;
          "Google".metaData.alias = "@g";
        };

        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # required for custom CSS
          "browser.toolbars.bookmarks.visibility" = "always"; # show bookmarks bar
        };
        userChrome = (builtins.readFile ../firefox/userChrome.css);
        userContent = (builtins.readFile ../firefox/userContent.css);
      };
    };

    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        llvm-vs-code-extensions.vscode-clangd
        vadimcn.vscode-lldb
        ms-vscode.cmake-tools
        twxs.cmake

        ms-python.python
        ms-python.vscode-pylance

        yzhang.markdown-all-in-one

        usernamehw.errorlens
        eamodio.gitlens
        sonarsource.sonarlint-vscode
        asvetliakov.vscode-neovim
      ];

      userSettings = {
        "editor.fontFamily" = "MesloLGS NF";
        "editor.rulers" = [ 120 ];
        "editor.guides.bracketPairs" = true;
        "editor.stickyScroll.enabled" = true;
        "editor.stickyTabStops" = true;
        "[nix]"."editor.tabSize" = 2;

        "audioCues.onDebugBreak" = true;
        "audioCues.taskFailed" = true;
        "audioCues.terminalCommandFailed" = true;

        "workbench.colorTheme" = "Gruvbox Material Dark";

        "git.autofetch" = true;

        "cmake.configureOnOpen" = true;

        "sonarlint.ls.javaHome" = "${pkgs.jdk}";
      };
    };

    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      enableScDaemon = false;
    };

    services.mako = {
      enable = true;
      anchor = "top-right";

      textColor = "#ebdbb8ff";
      backgroundColor = "#282828bb";

      borderColor = "#d79921cc";
      borderRadius = 6;
      borderSize = 1;

      defaultTimeout = 10000;

      font = "Cantarell 12";
      format = "<sup>%a</sup>\\n<b>%s</b>\\n%b";
      groupBy = "app-name";
      icons = true;

      margin = "5";
      padding = "8";

      progressColor = "source #383838ff";

      extraConfig = ''
        on-notify=exec mpv ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/message.oga --volume=150
        on-button-middle=dismiss-group

        # criteria-based settings
        [grouped]
        format=<sup>(%g) %a</sup>\n<b>%s</b>\n%b
        
        [urgency=critical]
        on-notify=exec mpv ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/dialog-warning.oga --volume=200
        border-size=2
        border-color=#cc2222cc
        
        [urgency=low]
        on-notify=none
        text-color=#bbab88
        
        [mode=away]
        default-timeout=0
        ignore-timeout=1
      '';
    };

    services.syncthing.enable = true;

    services.gammastep = {
      enable = true;
      provider = "manual";
      latitude = 39.59;
      longitude = -104.68;
      temperature.day = 6500;

      settings.general = {
        adjustment-method = "wayland";
      };
    };

    xdg.desktopEntries.discord = let
      ffd = pkgs.fetchFromGitHub {
        owner = "bazuin-32";
        repo = "ff-discord-launcher";
        rev = "5bd0c97500883a8fc6a695385843849ce422e5a6";
        hash = "sha256-vz+CNylgGebq3FZPHsI/FLfplsaEyiZdPS0rKWR86v0=";
      };
    in {
      name = "Discord";
      genericName = "Internet Messenger";
      categories = [ "Network" "InstantMessaging" ];
      exec = "${ffd}/discord.sh %U";
      terminal = false;
    };

    # make a symlink that can be pointed to from `/lib` so prebuilt binaries can work
    home.file.".local/lib/ld-linux-x86-64.so.2".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.glibc}/lib/ld-linux-x86-64.so.2";
    home.file.".local/lib/libuuid.so.1".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.util-linux.lib}/lib/libuuid.so.1";
    home.file.".local/lib/libX11.so.6".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.xorg.libX11}/lib/libX11.so.6";
    home.file.".local/lib/libX11-xcb.so.1".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.xorg.libX11}/lib/libX11-xcb.so.1";
    home.file.".local/lib/libXft.so.2".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.xorg.libXft}/lib/libXft.so.2";
    home.file.".local/lib/libstdc++.so.6".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.gcc-unwrapped.lib}/lib/libstdc++.so.6";
    home.file.".local/lib/libgobject-2.0.so.0".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.glib.out}/lib/libgobject-2.0.so.0";
    home.file.".local/lib/libglib-2.0.so.0".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.glib.out}/lib/libglib-2.0.so.0";
    home.file.".local/lib/libgio-2.0.so.0".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.glib.out}/lib/libgio-2.0.so.0";
    home.file.".local/lib/libnss3.so".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.nss}/lib/libnss3.so";
    home.file.".local/lib/libnssutil3.so".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.nss}/lib/libnssutil3.so";
    home.file.".local/lib/libsmime3.so".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.nss}/lib/libsmime3.so";
    home.file.".local/lib/libnspr4.so".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.nspr}/lib/libnspr4.so";
    home.file.".local/lib/libXcomposite.so.1".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.xorg.libXcomposite}/lib/libXcomposite.so.1";
    home.file.".local/lib/libXcursor.so.1".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.xorg.libXcursor}/lib/libXcursor.so.1";
    home.file.".local/lib/libXdamage.so.1".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.xorg.libXdamage}/lib/libXdamage.so.1";
    home.file.".local/lib/libXext.so.6".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.xorg.libXext}/lib/libXext.so.6";
    home.file.".local/lib/libXfixes.so.3".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.xorg.libXfixes}/lib/libXfixes.so.3";
    home.file.".local/lib/libXi.so.6".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.xorg.libXi}/lib/libXi.so.6";
    home.file.".local/lib/libXrender.so.1".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.xorg.libXrender}/lib/libXrender.so.1";
    home.file.".local/lib/libXtst.so.6".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.xorg.libXtst}/lib/libXtst.so.6";
    home.file.".local/lib/libXss.so.1".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.xorg.libXScrnSaver}/lib/libXss.so.1";
    home.file.".local/lib/libXrandr.so.2".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.xorg.libXrandr}/lib/libXrandr.so.2";
    home.file.".local/lib/libexpat.so.1".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.expat}/lib/libexpat.so.1";
    home.file.".local/lib/libdbus-1.so.3".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.dbus.lib}/lib/libdbus-1.so.3";
    home.file.".local/lib/libasound.so.2".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.alsa-lib}/lib/libasound.so.2";
    home.file.".local/lib/libpangocairo-1.0.so.0".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.pango.out}/lib/libpangocairo-1.0.so.0";
    home.file.".local/lib/libpango-1.0.so.0".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.pango.out}/lib/libpango-1.0.so.0";
    home.file.".local/lib/libatk-1.0.so.0".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.at-spi2-core}/lib/libatk-1.0.so.0";
    home.file.".local/lib/libatk-bridge-2.0.so.0".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.at-spi2-core}/lib/libatk-bridge-2.0.so.0";
    home.file.".local/lib/libatspi.so.0".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.at-spi2-core}/lib/libatspi.so.0";
    home.file.".local/lib/libudev.so.1".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.systemdMinimal}/lib/libudev.so.1";
    home.file.".local/lib/libvulkan.so.1".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.vulkan-loader}/lib/libvulkan.so.1";
  };

  environment.variables = {
    EDITOR = "nvim";
    SUDO_EDITOR = "nvim";
    VISUAL = "nvim";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    MOZ_ENABLE_WAYLAND = "1";
    XPLR_BOOKMARKS_FILE = "$HOME/.local/share/xplr/bookmarks";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    PATH = "$PATH:$HOME/.config/bin:$HOME/.local/bin";
  };
}
