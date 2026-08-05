{ lib, config, inputs, pkgs, ... }:

{
  programs.dconf.enable = true; # requred for gtk themes
  programs.zsh.enable = true; # required to be able to set user's default shell, even though zsh is configured in home-manager
  security.pam.services.hyprlock = {}; # without this it is impossible to unlock

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  users.users.ameen = {
    isNormalUser = true;
    extraGroups = [ "wheel" "cdrom" "docker" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  virtualisation.docker.enable = true;

  environment.pathsToLink = [ "/share/zsh" ]; # for zsh completions, see https://rycee.gitlab.io/home-manager/options.html#opt-programs.zsh.enableCompletion
  home-manager.useUserPackages = true;
  home-manager.users.ameen = { config, pkgs, ... }: {
    home.stateVersion = "23.05";
    nixpkgs.config.allowUnfree = true;
    programs.home-manager.enable = true;
    imports = [
      inputs.ags.homeManagerModules.default
      inputs.hyprcursor-phinger.homeManagerModules.hyprcursor-phinger
    ];

    home.packages = with pkgs; [
      onlyoffice-desktopeditors
      fastfetch
      bun # for using typescript with ags
      grim
      slurp
      imagemagick
      rofi
      wl-clipboard
      meslo-lgs-nf
      jdk # required for sonarlint vscode extension
      socat
      pipe-rename # required for batch rename in xplr
      xplr
      nix-index
      zip
      unzip
      p7zip
      unrar
      file
      fd
      nomacs
      wineWow64Packages.wayland
      yt-dlp
      bc
      calc
      acpi
      powertop
      nmap
      dig
      nvd
      traceroute
      pavucontrol
      exiftool
      ncdu
      sysstat
      python3
      python314Packages.ipython
      ffmpeg
      obs-studio
      googleearth-pro
      telegram-desktop
      units
      obsidian
      slack
      freerdp
      man-pages
      firefoxpwa

      cantarell-fonts
      corefonts
      vista-fonts
      vazirmatn
    ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

    fonts = {
      # enableDefaultPackages = true;
      # packages = with pkgs; [
      #   cantarell-fonts
      #   corefonts
      #   vistafonts
      #   vazirmatn
      # ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

      fontconfig = {
        enable = true;
        defaultFonts = {
          serif = [ "DejaVu Serif" "Vazirmatn" ];
          sansSerif = [ "DejaVu Sans" "Vazirmatn" ];
          monospace = [ "DejaVu Sans Mono" "Vazirmatn" ];
        };
      };
    };

    wayland.windowManager.hyprland = let
      lua = lib.generators.mkLuaInline;

      mod = "SUPER";
      term = "foot";
      launcher = "~/.config/rofi/bin/launcher_text";
      lockCmd = "${pkgs.hyprlock}/bin/hyprlock";
      powermenu = "~/.config/rofi/bin/powermenu";

      /*
        Produce an hl.bind(key, dispatcher) call.

        `dispatcher` must be an inline Lua expression such as:

          lua ''hl.dsp.exec_cmd("foot")''
      */
      mkBind = key: dispatcher: {
        _args = [
          key
          dispatcher
        ];
      };

      execBind = key: command:
        mkBind key (lua ''hl.dsp.exec_cmd(${builtins.toJSON command})'');

      workspaceBind = workspace: key:
        mkBind "${mod} + ${key}" (
          lua "hl.dsp.focus({ workspace = ${toString workspace} })"
        );

      moveToWorkspaceBind = workspace: key:
        mkBind "ALT + ${key}" (
          lua "hl.dsp.window.move({ workspace = ${toString workspace} })"
        );

      /*
        Convert workspace 10 to key 0:

          workspace 1  -> key 1
          ...
          workspace 9  -> key 9
          workspace 10 -> key 0
      */
      workspaceKey = workspace:
        toString (lib.mod workspace 10);

      workspaceBindings =
        builtins.genList (
          index:
          let
            workspace = index + 1;
          in
          workspaceBind workspace (workspaceKey workspace)
        ) 10;

      moveToWorkspaceBindings =
        builtins.genList (
          index:
          let
            workspace = index + 1;
          in
          moveToWorkspaceBind workspace (workspaceKey workspace)
        ) 10;
    in {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;

      configType = "lua";

      settings = {
        /*
          This produces:

            hl.config({
              general = { ... },
              input = { ... },
              ...
            })
        */
        config = {
          general = {
            gaps_in = 5;
            gaps_out = 8;
            border_size = 2;

            col = {
              active_border = "rgba(056f05cc)";
              inactive_border = "rgba(ebdbb888)";
            };
          };

          input = {
            sensitivity = 0.5;

            kb_layout = "us,ir";
            kb_variant = ",pes_keypad";
            kb_options = "compose:ralt,grp:alt_space_toggle";

            follow_mouse = 1;
            numlock_by_default = true;
          };

          dwindle = {
            smart_split = true;
            precise_mouse_move = true;
          };

          decoration = {
            rounding = 6;

            active_opacity = 0.90;
            inactive_opacity = 0.80;

            blur = {
              enabled = true;
              size = 4;
              passes = 1;
            };

            dim_inactive = true;
            dim_strength = 0.2;
          };

          animations = {
            enabled = true;
          };

          misc = {
            mouse_move_enables_dpms = true;
            key_press_enables_dpms = true;

            # Reduce unnecessary rendering and automatic work.
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            disable_autoreload = true;
          };
        };

        workspace_rule = [
          {
            workspace = "special:special";
            gaps_out = 100;
            on_created_empty = "${term}";
          }
        ];

        curve = [
          {
            _args = [
              "mybez"
              {
                type = "bezier";
                points = [
                  [ 0.6 0.5 ]
                  [ 0.1 1.0 ]
                ];
              }
            ];
          }

          {
            _args = [
              "inactive_dimmer"
              {
                type = "bezier";
                points = [
                  [ 0.3 0.4 ]
                  [ 0.6 0.7 ]
                ];
              }
            ];
          }
        ];

        animation = [
          {
            leaf = "windows";
            enabled = true;
            speed = 6;
            bezier = "mybez";
            style = "popin 70%";
          }

          {
            leaf = "border";
            enabled = true;
            speed = 7;
            bezier = "mybez";
          }

          {
            leaf = "fade";
            enabled = true;
            speed = 7;
            bezier = "mybez";
          }

          {
            leaf = "fadeDim";
            enabled = true;
            speed = 5;
            bezier = "inactive_dimmer";
          }

          {
            leaf = "workspaces";
            enabled = true;
            speed = 4;
            bezier = "mybez";
          }
        ];

        bind =
          [
            (execBind "${mod} + RETURN" term)

            (mkBind "${mod} + TAB" (
              lua "hl.dsp.window.cycle_next({ next = true })"
            ))

            (mkBind "${mod} + Q" (
              lua "hl.dsp.window.close()"
            ))

            (execBind "${mod} + SPACE" launcher)
            (execBind "${mod} + CTRL + L" lockCmd)
            (execBind "${mod} + P" powermenu)

            /*
              Your old `togglespecialworkspace` had no workspace name, so this
              targets the unnamed special workspace.
            */
            (mkBind "${mod} + S" (
              lua ''hl.dsp.workspace.toggle_special("")''
            ))

            (mkBind "${mod} + H" (
              lua ''hl.dsp.window.move({ direction = "l" })''
            ))

            (mkBind "${mod} + J" (
              lua ''hl.dsp.window.move({ direction = "d" })''
            ))

            (mkBind "${mod} + K" (
              lua ''hl.dsp.window.move({ direction = "u" })''
            ))

            (mkBind "${mod} + L" (
              lua ''hl.dsp.window.move({ direction = "r" })''
            ))
          ]
          ++ workspaceBindings
          ++ moveToWorkspaceBindings
          ++ [
            (mkBind "ALT + S" (
              lua ''hl.dsp.window.move({ workspace = "special" })''
            ))

            (mkBind "${mod} + T" (
              lua ''hl.dsp.window.float({ action = "toggle" })''
            ))

            (execBind
              "XF86AudioRaiseVolume"
              "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
            )

            (execBind
              "XF86AudioLowerVolume"
              "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
            )

            (execBind
              "XF86AudioMute"
              "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
            )

            (execBind
              "Print"
              "~/.config/bin/screenshot.sh"
            )

            (mkBind "${mod} + F" (
              lua ''
                hl.dsp.window.fullscreen({
                  mode = "fullscreen",
                  action = "toggle",
                })
              ''
            ))

            # Laptop display brightness.
            (execBind
              "XF86MonBrightnessUp"
              "brightnessctl set 5%+"
            )

            (execBind
              "XF86MonBrightnessDown"
              "brightnessctl set 5%-"
            )

            # Desktop keyboard RGB profiles.
            (execBind
              "CTRL + SHIFT + ALT + 1"
              "rgb_keyboard -a 1"
            )

            (execBind
              "CTRL + SHIFT + ALT + 2"
              "rgb_keyboard -a 2"
            )

            (execBind
              "CTRL + SHIFT + ALT + 3"
              "rgb_keyboard -a 3"
            )

            (mkBind "${mod} + mouse:272"
              (lua "hl.dsp.window.drag()"))

            (mkBind "${mod} + mouse:273"
              (lua "hl.dsp.window.resize()"))
          ];

        /*
          Several rules targeting the same window have been combined into one
          structured rule. This is equivalent to the separate old windowrule
          entries.
        */
        window_rule = [
          {
            match = {
              title = ".*BeamNG.*";
            };

            no_blur = true;
            opaque = true;
            fullscreen = true;
          }

          {
            match = {
              title = "Open Folder";
            };

            float = true;
            size = "60% 80%";
            center = true;
          }

          {
            match = {
              title = "Open File";
            };

            float = true;
            size = "60% 80%";
            center = true;
          }

          {
            match = {
              class = "DesktopEditors";
            };

            tile = true;
          }

          {
            match = {
              title = "Picture-in-Picture";
            };

            float = true;
            pin = true;
            no_blur = true;
            opaque = true;
          }
        ];

        env = [
          {
            _args = [
              "HYPRCURSOR_THEME"
              "phinger-cursors-dark"
            ];
          }

          {
            _args = [
              "HYPRCURSOR_SIZE"
              "24"
            ];
          }
        ];

        on = {
          _args = [
            "hyprland.start"

            (lua ''
              function()
                hl.exec_cmd(
                  "systemctl --user import-environment " ..
                  "WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
                )

                hl.exec_cmd(
                  "systemctl --user start " ..
                  "hypridle.service hyprpaper.service"
                )

                hl.exec_cmd("gammastep -v -l 39.59:-104.68")
                hl.exec_cmd("ags run")
                hl.exec_cmd("thunderbird")
              end
            '')
          ];
        };
      };
    };

    programs.hyprcursor-phinger.enable = true;
    home.pointerCursor = {
      enable = true;
      name = "phinger-cursors-dark";
      package = pkgs.phinger-cursors;
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };

    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          grace = 10;
        };

        background = [{
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
          noise = 0.02;
        }];

        label = [
          {
            halign = "center";
            valign = "center";
            position = "0, 60";

            text = "Hi, $USER";
            text_align = "center";
            color = "rgb(ebdbb8)";
          }
          {
            halign = "center";
            valign = "center";
            position = "0, 20";

            text = "cmd[update:60000] date '+%I:%M %p'";
            text_align = "center";
            color = "rgb(dbcba8)";
            font_size = 12;
          }
        ];

        input-field = [{
          size = "250, 50";
          halign = "center";
          valign = "center";
          position = "0, -20";

          placeholder_text = "Password";
          fail_text = "$FAIL <b>($ATTEMPTS)</b>";

          fade_timeout = "10000";

          outer_color = "rgba(d79921cc)";
          inner_color = "rgba(202828f0)";
          font_color = "rgb(ebdbb8)";
          fail_color = "rgb(204, 34, 34)";
          capslock_color = "rgb(204, 34, 34)";

          outline_thickness = 1;
          rounding = 5;

        }];
      };
    };

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock"; # don't start more than 1 instance
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };

        listener = [
          {
            timeout = 300; # 5 min
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 330; # 5.5 min
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            timeout = 1800; # 30 min
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };

    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = false;
        splash = true;
        splash_offset = 5;
        splash_color = "rgb(ebdbb8)";

        wallpaper = [
          {
            monitor = "";
            path = "~/.local/share/wallpapers/gruvbox-forest.jpg";
          }
        ];
      };
    };
    
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
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

      initContent = ''
        setopt extendedglob
        setopt globstarshort
        setopt autopushd # make cd keep a dir stack

        . ~/.config/zsh/functions.zsh

        fastfetch
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
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.8.0";
            sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
          };
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

        nix-gc-full = "sudo nix-collect-garbage --delete-older-than 7d && nix-collect-garbage --delete-older-than 7d && sudo nixos-rebuild boot";
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
        colors-dark = {
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

    programs.eza.enable = true;

    programs.bat = {
      enable = true;
      config = {
        theme = "gruvbox-dark";
      };
    };

    programs.git = {
      enable = true;
      settings = {
        user.name = "bazuin-32";
        user.email = "ameenpiano@gmail.com";
        push.autoSetupRemote = true;
	#url = {
	#	"ssh://git@github.com/" = {
	#        insteadOf = "https://github.com/";
	#    };
	#};
      };
      signing.format = null;
    };
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      withRuby = false;
      withPython3 = true;
    };

    programs.tealdeer = {
      enable = true;
    };

    programs.mpv = {
      enable = true;
      config = {
        sub-font-size = 30;
      };
    };

    programs.ags = {
      enable = true;
      extraPackages = with pkgs; [
        inputs.astal.packages.${pkgs.system}.hyprland
        inputs.astal.packages.${pkgs.system}.tray
        inputs.astal.packages.${pkgs.system}.battery
        inputs.astal.packages.${pkgs.system}.network
        inputs.astal.packages.${pkgs.system}.wireplumber
        inputs.astal.packages.${pkgs.system}.notifd
      ];
    };



    gtk = {
      enable = true;
      font = {
        name = "Cantarell";
        size = 12;
      };
      theme.name = "Adwaita-dark";
      gtk4.theme = config.gtk.theme;
      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
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
      configPath = "${config.xdg.configHome}/mozilla/firefox";
      nativeMessagingHosts = [ pkgs.firefoxpwa ];
      profiles.default = {
        name = "dev-edition-default";
        isDefault = true;
        
        search.default = "google";
        search.force = true;
        search.engines = {
          "Nix Packages" = {
            urls = [{ template = "https://search.nixos.org/packages?type=packages&channel=unstable&query={searchTerms}"; }];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };

          "NixOS Wiki" = {
            urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
            icon = "https://nixos.wiki/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = [ "@nw" ];
          };

          "NixOS Options" = {
            urls = [{ template = "https://search.nixos.org/options?type=options&channel=unstable&query={searchTerms}"; }];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@no" ];
          };

          "bing".metaData.hidden = true;
          "google".metaData.alias = "@g";
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
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          llvm-vs-code-extensions.vscode-clangd
          vadimcn.vscode-lldb
          ms-vscode.cmake-tools
          twxs.cmake
          xaver.clang-format
          ms-vscode.makefile-tools

          ms-python.python
          ms-python.vscode-pylance

          yzhang.markdown-all-in-one

          usernamehw.errorlens
          eamodio.gitlens
          sonarsource.sonarlint-vscode
          asvetliakov.vscode-neovim

	  ms-vscode-remote.remote-ssh
        ];

        userSettings = {
          "editor.fontFamily" = "MesloLGS NF";
          "editor.rulers" = [ 120 ];
          "editor.guides.bracketPairs" = true;
          "editor.stickyScroll.enabled" = true;
          "editor.stickyTabStops" = true;
          "[nix]"."editor.tabSize" = 2;

          "workbench.colorTheme" = "Gruvbox Material Dark";

          "git.autofetch" = true;

          "cmake.configureOnOpen" = true;

          "sonarlint.ls.javaHome" = "${pkgs.jdk}";

          # for vscode-neovim
          "extensions.experimental.affinity" = { "asvetliakov.vscode-neovim" = 1; };

          # for clang-format
          "editor.defaultFormatter" = "xaver.clang-format";
          # "editor.formatOnSave" = true;
          "clang-format.executable" = "${pkgs.clang-tools}/bin/clang-format";
          "C_Cpp.codeAnalysis.clangTidy.enabled" = true;
          "C_Cpp.codeAnalysis.clangTidy.path" = "${pkgs.clang-tools}/bin/clang-tidy";
          "C_Cpp.errorSquiggles" = "Enabled";
          "C_Cpp.codeAnalysis.runAutomatically" = true;
        };
      };
    };


    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      enableScDaemon = false;
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
        rev = "f8265a2ca2dc9e1658679e95d57e8cca4362c7f2";
        hash = "sha256-lCEjI61wc3VK1LoEXP0Qd9rePSGmekZikZJ2Xf3ikVs=";
      };
    in {
      name = "Discord";
      genericName = "Internet Messenger";
      categories = [ "Network" "InstantMessaging" ];
      exec = "${ffd}/discord.sh %U";
      terminal = false;
    };
  };

  environment.variables = {
    EDITOR = "nvim";
    SUDO_EDITOR = "nvim";
    VISUAL = "nvim";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    MANROFFOPT="-c";
    MOZ_ENABLE_WAYLAND = "1";
    XPLR_BOOKMARKS_FILE = "$HOME/.local/share/xplr/bookmarks";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    PATH = "$PATH:$HOME/.config/bin:$HOME/.local/bin";
  };
}
