{
  config,
  pkgs,
  lib,
  ...
}: let
  unstable = import <nixos-unstable> {config = {allowUnfree = true;};};
in {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) (
      if (config.per_system_config.primary_account == "udh" && config.per_system_config.gui_system != "tui" )
      then [
        "google-chrome"
      ]
      else []
    );

  programs.zsh.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.udh = {
    isNormalUser = true;
    description = "udh";
    extraGroups = ["networkmanager" "wheel" "disk" "audio" "dialout" "video" "input"];
    shell = pkgs.zsh;
    # TODO: Maybe
    #openssh.authorizedKeys.keys = [
    #   "ssh-ed25519 AAAAC3NzaC1lZDI1.... username@tld"
    #];
    packages = with pkgs;
      [
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
      ]
      ++ (
        if (config.per_system_config.primary_account == "udh")
        then [
          #moreutils cpufrequtils binutils usbutils
          #sh-z sicp inetutils xpdf
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
        ] ++ (if(config.per_system_config.gui_system == "tui")
             then [ ]
              else [ google-chrome ])
        else []
      );
  };
}
