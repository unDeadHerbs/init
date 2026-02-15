# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  ...
}: with lib; let
  unstable = import <nixos-unstable> {config = {allowUnfree = true;};};
in {
  options.per_system_config = {
    auto_login_user = lib.mkOption {
      type = types.str;
      default = "udh";
      description = "Name of default user";
    };
  };
  imports = [
    ../nix/common.nix
  ];
  config={
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
  # sudo nix-channel --add https://channels.nixos.org/nixos-25.11 nixos
  # sudo nixos-rebuild switch --upgrade

  # X11
  services.xserver = {
    enable = true;
    xrandrHeads = [
      {
        monitorConfig = "Option \"Rotate\" \"left\"";
        output = "HDMI-1";
        primary = true;
      }
    ];
    xkb = {
      layout = "us";
      variant = "";
    };
    displayManager.lightdm.enable = true;
    windowManager.i3.enable = true;
  };
  services.displayManager = {
    defaultSession = "none+i3";
    autoLogin.enable = true;
    autoLogin.user = config.per_system_config.auto_login_user;
  };
  services.picom.enable = true; # for transparency

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "google-chrome"
    ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.udh = {
    isNormalUser = true;
    description = "udh";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
    packages = with pkgs; [
      #moreutils cpufrequtils binutils usbutils
      #sh-z sicp inetutils xpdf
      alejandra
      alsa-utils
      aspell
      (aspellWithDicts
        (dicts: with dicts; [en en-computers])) # en-science]))
      bat
      clang
      cowsay
      curl
      dmenu
      ed
      emacs
      evince
      eza
      feh
      ffmpeg
      figlet
      flameshot
      git
      gnumake
      google-chrome
      hunspell
      hunspellDicts.en_US
      hunspellDicts.en_GB-ise
      hunspellDicts.en_GB-ize
      i3status
      imagemagick
      libnotify
      links2
      lynx
      mattermost-desktop
      mc
      mpv
      hyfetch
      netcat
      p7zip
      pandoc
      progress
      unstable.R
      unstable.rstudio
      scrot
      sl
      sshfs
      texliveFull
      tmux
      unzip
      wdiff
      xfce.xfce4-terminal
      #youtube-dl
      zsh-autosuggestions
    ];
  };

  # Programs with extra config requirements
  programs.xfconf.enable = true;
  programs.zsh.enable = true;
  services.emacs.enable = true;
  programs.firefox.enable = true;
  programs.mosh.enable = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    mattermost
    nginx
    noip
  ];

  # Public Servers
  networking.firewall.allowedTCPPorts = [80 443 8065];
  security.acme = {
    acceptTerms = true;
    defaults.email = "undeadherbs@gmail.com";
  };
  services.mattermost = {
    enable = true;
    siteUrl = "http://udh.ddns.net";
  };
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      # Replace with the domain from your siteUrl
      "udh.ddns.net" = {
        forceSSL = true; # Enforce SSL for the site
        enableACME = true; # Enable SSL for the site
        locations."/" = {
          proxyPass = "http://127.0.0.1:8065"; # Route to Mattermost
          proxyWebsockets = true;
        };
      };
    };
  };

  #environment.etc."nextcloud-admin-pass".text = "PWD123456789";
  #services.nextcloud = {
  #  enable = true;
  #  package = pkgs.nextcloud31;
  #  hostName = "localhost";
  #  config.adminpassFile = "/etc/nextcloud-admin-pass";
  #  config.dbtype = "sqlite";
  #  settings.trusted_domains = ["sia.local"];
  #};
  };
}
