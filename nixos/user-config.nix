{ config, pkgs, ... }:

{
  programs.dconf.enable = true; # requred for gtk themes
  programs.zsh.enable = true; # required to be able to set user's default shell, even though zsh is configured in home-manager

  users.users.ameen = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  environment.pathsToLink = [ "/share/zsh" ]; # for zsh completions, see https://rycee.gitlab.io/home-manager/options.html#opt-programs.zsh.enableCompletion
  home-manager.useUserPackages = true;
  home-manager.users.ameen = { pkgs, ... }: {
    home.stateVersion = "23.05";
    nixpkgs.config.allowUnfree = true;
    programs.home-manager.enable = true;

    home.packages = with pkgs; [
      thunderbird
      onlyoffice-bin
      mpv
      neofetch
      eww-wayland
      swaybg
      swaylock-effects
      grim
      slurp
      imagemagick
      rofi-wayland
      wl-clipboard
      meslo-lgs-nf
      nerdfonts
      jdk # required for sonarlint vscode extension
      socat
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
        main = {
          font = "MesloLGS NF:size=7";
        };
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

    gtk.enable = true;
    gtk.theme.name = "Adwaita-dark"; # TODO: use a gruvbox theme here

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
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };

          "NixOS Wiki" = {
            urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
            iconUpdateURL = "https://nixos.wiki/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = [ "@nw" ];
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
        "[nix]"."editor.tabSize" = 2;
        "sonarlint.ls.javaHome" = "${pkgs.jdk}";
      };
    };

    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
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
  };

  environment.variables = {
    EDITOR = "nvim";
    SUDO_EDITOR = "nvim";
    VISUAL = "nvim";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    MOZ_ENABLE_WAYLAND = "1";
    XPLR_BOOKMARKS_FILE = "$HOME/.local/share/xplr/bookmarks";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    PATH = "$PATH:$HOME/.config/bin";
  };
}
