{ config, pkgs, ... }:

{
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
      firefox
      thunderbird
      onlyoffice-bin
      mpv
      vscode
      neofetch
      meslo-lgs-nf
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

    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
    };

    programs.git = {
      enable = true;
      userName = "bazuin-32";
      userEmail = "ameenpiano@gmail.com";
      extraConfig.push.autoSetupRemote = true;
    };
    programs.neovim = {
      enable = true;
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
  };
}
