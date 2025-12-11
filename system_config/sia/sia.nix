# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  ...
}: let
  unstable = import <nixos-unstable> {config = {allowUnfree = true;};};
in {
  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  boot.supportedFilesystems = ["ntfs"];
  boot.loader.grub.splashImage = ../../bg/nix-wallpaper-mosaic-blue.png;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  system.autoUpgrade = {
    enable = true; # periodically execute systemd service nixos-upgrade.service
    allowReboot = false; # If false, run nixos-rebuild switch --upgrade
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;
  services.avahi = {
    enable = true;
    publish.enable = true;
    publish.workstation = true;
    publish.userServices = true;
  };

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

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
    autoLogin.user = "udh";
  };
  services.picom.enable = true; # for transparency

  fonts.packages = with pkgs; [
    fira
    fira-code
  ];

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
    barrier
    htop
    wget
    vim
  ];

  # Enable Barrier
  systemd.services.barrierc = {
    wantedBy = ["graphical.target"];
    after = ["network.target"];
    description = "Start the brarrier client for uDH.";
    serviceConfig = {
      Type = "simple";
      User = "udh";
      ExecStart = ''${pkgs.barrier}/bin/barrierc -f --restart --disable-crypto 192.168.0.31'';
      ExecStop = ''${pkgs.procps}/bin/pkill barrierc'';
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.X11Forwarding = true;
  };

  # Run local servers in containers
  networking = {
    #bridges.br0.interfaces = ["eno1"]; # Adjust interface accordingly

    # Get bridge-ip with DHCP
    #useDHCP = true;
    #interfaces."br0".useDHCP = true;

    # Set bridge-ip static
    #interfaces."br0".ipv4.addresses = [
    #  {
    #    address = "192.168.0.100";
    #    prefixLength = 24;
    #  }
    #];
    #defaultGateway = "192.168.0.1";
    #nameservers = ["192.168.0.1"];
  };
  #networking.nat = {
  #  enable = true;
  #  internalInterfaces = ["ve-+"];
  #  externalInterface = "eno1";
  #  # Lazy IPv6 connectivity for the container
  #  enableIPv6 = true;
  #};

  # Run a nextcloud server
  #containers.nextcloud-server = {
  #  autoStart = true;
  #  privateNetwork = true;
  #  hostBridge = "br0"; # Specify the bridge name
  #  localAddress = "192.168.0.112/24";
  #  #hostAddress = "192.168.0.40";
  #  #localAddress = "192.168.0.112";
  #  #hostAddress6 = "fc00::1";
  #  #localAddress6 = "fc00::2";
  #  config = {
  #    config,
  #    pkgs,
  #    lib,
  #    ...
  #  }: {
  #    environment.etc."nextcloud-admin-pass".text = "PWD123456789";
  #    services.nextcloud = {
  #      enable = true;
  #      package = pkgs.nextcloud31;
  #      hostName = "localhost";
  #      config.adminpassFile = "/etc/nextcloud-admin-pass";
  #      config.dbtype = "sqlite";
  #      settings.trusted_domains = ["sia.local"];
  #    };
  #
  #    networking = {
  #      firewall.allowedTCPPorts = [80 443];
  #      # Use systemd-resolved inside the container
  #      # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
  #      useHostResolvConf = lib.mkForce false;
  #    };
  #
  #    services.resolved.enable = true;
  #
  #    system.stateVersion = "24.11";
  #  };
  #};

  # Run a mattermost server
  #containers.mattermost-server = {
  #  autoStart = true;
  #  privateNetwork = true;
  #  hostBridge = "br0"; # Specify the bridge name
  #  localAddress = "192.168.0.113/24";
  #  #hostAddress = "192.168.100.40";
  #  #localAddress = "192.168.100.113";
  #  #hostAddress6 = "fc00::1";
  #  #localAddress6 = "fc00::3";
  #  config = {
  #    config,
  #    pkgs,
  #    lib,
  #    ...
  #  }: {
  #    services.mattermost = {
  #      enable = true;
  #      siteUrl = "https://mattermost.example.com"; # Set this to the URL you will be hosting the site on.
  #    };
  #    networking = {
  #      firewall.allowedTCPPorts = [80 443];
  #      # Use systemd-resolved inside the container
  #      # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
  #      useHostResolvConf = lib.mkForce false;
  #    };
  #
  #    services.resolved.enable = true;
  #
  #    system.stateVersion = "24.11";
  #  };
  #};
}
