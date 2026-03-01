{
  config,
  pkgs,
  lib,
  ...
}: let
  unstable = import <nixos-unstable> {config = {allowUnfree = true;};};
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
    (lib.mkIf (config.per_system_config.primary_account == "udh") {
      nixpkgs.config.allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) (
          if (config.per_system_config.gui_system != "tui")
          then [
            "google-chrome"
          ]
          else []
        );

      services.emacs.enable = true;

      # This will probably switch to only X in the future
      programs.xfconf.enable = config.per_system_config.gui_system != "tui";

      users.users.udh.packages = with pkgs;
        [
          alsa-utils
          (aspellWithDicts
            (dicts: with dicts; [en-computers])) # en-science]))
          clang
          cowsay
          dmenu
          ed
          emacs
          feh
          ffmpeg
          figlet
          flameshot
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
          #unstable.R
          #unstable.rstudio
          scrot
          sl
          texliveFull
          xfce.xfce4-terminal
          #youtube-dl
          zstd
        ]
        ++ (
          if (config.per_system_config.gui_system != "tui")
          then [google-chrome]
          else []
        );
    })
  ]
