# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  ...
}: let
  # sudo nix-channel --add https://channels.nixos.org/nixos-unstable nixos-unstable
  # sudo nix-channel --update
  unstable = import <nixos-unstable> {config = {allowUnfree = true;};};
in {
  # Bootloader.
  boot = {
    loader.grub.enable = true;
    loader.grub.device = "/dev/sda";
    loader.grub.useOSProber = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

  system.autoUpgrade.enable = true; # periodically execute systemd service nixos-upgrade.service
  system.autoUpgrade.allowReboot = false; # If false, run nixos-rebuild switch --upgrade

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  services.avahi = {
    enable = true;
    publish.enable = true;
    publish.workstation = true;
    publish.userServices = true;
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  #i18n.defaultLocale = "uk_UA.UTF-8";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = ["uk_UA.UTF-8/UTF-8" "ru_RU.UTF-8/UTF-8" "en_US.UTF-8/UTF-8"];

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

  # Display
  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
      xrandrHeads = [
        {
          monitorConfig = "Option \"Rotate\" \"left\"";
          output = "VGA-1";
          primary = true;
        }
        {
          monitorConfig = "Option \"Ignore\" \"true\"";
          output = "LVDS-1";
        }
      ];
      displayManager = {
        #lightdm.enable = true;
      };
      windowManager.i3.enable = true;
      #desktopManager.xfce.enable = true;
    };
    displayManager = {
      defaultSession = "none+i3";
      autoLogin.enable = true;
      autoLogin.user = "reiko";
    };
  };

  fonts.packages = with pkgs; [
    fira
    fira-code
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Sound
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "google-chrome"
    ];

  users.users.reiko = {
    isNormalUser = true;
    description = "Reiko";
    extraGroups = ["networkmanager" "disk" "audio" "dialout" "video" "input" "wheel"];
    packages = with pkgs; [
    ];
  };

  users.users.udh = {
    isNormalUser = true;
    description = "udh";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
    packages = with pkgs; [
      alejandra
      bat
      git
      hyfetch
      netcat
      scrot
      stow
      tmux
      unzip
      wdiff
      zsh-autosuggestions
    ];
  };
  # Enable sudo without having a user password
  security.sudo.wheelNeedsPassword = false;

  # Install core programs
  programs.zsh.enable = true;
  programs.mosh.enable = true;
  programs.firefox.enable = true;
  environment.systemPackages = with pkgs; [
    deskflow
    htop
    wget
    vim
  ];

  # Enable Deskflow
  systemd.services.deskflow = {
    # this is the "node" in the systemd dependency graph that will run the service
    wantedBy = ["graphical.target"];
    # systemd service unit declarations involve specifying dependencies and order of execution of systemd nodes
    after = ["network.target"];
    description = "Start the deskflow client for Reiko.";
    serviceConfig = {
      # see systemd man pages for more information on the various options for "Type": "notify"
      # specifies that this is a service that waits for notification from its predecessor (declared in
      # `after=`) before starting
      Type = "simple";
      User = "reiko";
      ExecStart = ''${pkgs.deskflow}/bin/deskflow-core client -f --restart 192.168.0.31'';
      ExecStop = ''${pkgs.procps}/bin/pkill deskflow-core'';
    };
  };

  # Kiosk Application
  systemd.services.firefox = {
    # this is the "node" in the systemd dependency graph that will run the service
    wantedBy = ["default.target"];
    # systemd service unit declarations involve specifying dependencies and order of execution of systemd nodes
    after = ["network.target"];
    wants = ["display-manager.service"];
    description = "Start the firefox kiosk for reiko.";
    serviceConfig = {
      # see systemd man pages for more information on the various options for "Type": "notify"
      # specifies that this is a service that waits for notification from its predecessor (declared in
      # `after=`) before starting
      Type = "simple";
      User = "reiko";
      Environment = "DISPLAY=:0";
      ExecStart = ''${pkgs.firefox}/bin/firefox --kiosk'';
      ExecStop = ''${pkgs.procps}/bin/pkill firefox'';
      Restart = "always";
      RestartSec = "10";
    };
  };

  # Setup Remote Administration
  services.openssh = {
    enable = true;
    settings.X11Forwarding = true;
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = "no";
  };
  services.tor = {
    enable = true;
    openFirewall = true;
    relay = {
      enable = true;
      role = "relay";
      onionServices.remoteAdmin = {
        version = 3;
        map = [
          {
            port = 1234;
            target = {
              addr = "[::1]";
              port = 22;
            };
          }
        ];
      };
    };
  };
}
