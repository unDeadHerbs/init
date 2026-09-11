{
  config,
  pkgs,
  lib,
  ...
}: let
  unstable = import <nixos-unstable> {config = {allowUnfree = true;};};
  tex = (pkgs.texlive.withPackages (
    ps: with ps; [
      dvisvgm dvipng # for preview and export as html
      wrapfig amsmath ulem hyperref capt-of
      scheme-basic pgf
      #(setq org-latex-compiler "lualatex")
      #(setq org-preview-latex-default-process 'dvisvgm)
    ]));
in
  lib.mkMerge [
    {
      programs.zsh.enable = true;
      users.users.udh = {
        isNormalUser = true;
        description = "udh";
        extraGroups = ["networkmanager" "wheel" "disk" "audio" "dialout" "video" "input"];
        shell = pkgs.zsh;
        packages = with pkgs; [
          alejandra
          bat
          eza
          i3status
          mc
          progress
          sshfs
          wdiff
          zsh
          zsh-autosuggestions
        ];
      };
    }
    (lib.mkIf (config.per_system_config.full_udh_account) {
      nixpkgs.config.allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) (
          if (config.per_system_config.gui_system != "tui")
          then [
            "google-chrome"
            # Only enabled on sia; but, allowing everywhere is fine
            "steam"
            "steam-unwrapped"
          ]
          else []
        );

      services.emacs.enable = true;
      
      services.picom.enable = true; # for transparency

      # This will probably switch to only X in the future
      programs.xfconf.enable = config.per_system_config.gui_system != "tui";
      programs.foot.enable = config.per_system_config.gui_system == "wayland";

      users.users.udh.packages = with pkgs;
        [
          alsa-utils
          (aspellWithDicts
            (dicts: with dicts; [en-computers])) # en-science]))
          clang
          clang-tools
          cowsay
          dmenu
          ed
          emacs
          feh
          ffmpeg
          figlet
          flameshot
          fzf
          gnumake
          hunspell
          hunspellDicts.en_US
          hunspellDicts.en_GB-ise
          hunspellDicts.en_GB-ize
          imagemagick
          libnotify
          links2
          lynx
          mattermost-desktop
          mpv
          pandoc
          python3
          #unstable.R
          #unstable.rstudio
          scrot
          sl
          telegram-desktop
          texliveFull
          tex
          uv
          xfce.xfce4-terminal
          #youtube-dl
          zstd
          
          # libstdc++.so.6 for Numpy and others
          # stdenv.cc.cc.lib
          (pkgs.python3.withPackages (python-pkgs: with python-pkgs; [
            # select Python packages here
            #pandas
            numpy
          ]))
        ]
        ++ (
          if (config.per_system_config.gui_system != "tui")
          then [google-chrome]
          else []
        );
    })
  ]
