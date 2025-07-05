# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  ...
}:
# let
# sudo nix-channel --add https://channels.nixos.org/nixos-unstable nixos-unstable
# sudo nix-channel --update
#unstable = import <nixos-unstable> {config = {allowUnfree = true;};};
#in
{
  # Bootloader.
  boot = {
    loader.grub = {
      enable = true;
      device = "/dev/sda";
      useOSProber = true;
      #splashImage = ../../bg/nix-wallpaper-mosaic-blue.png;
    };
    plymouth = {
      enable = true;
    };
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=0"
      "rd.systemd.show_status=false"
    ];
    loader.timeout = 0;
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
  system.stateVersion = "24.05"; # Did you read the comment?

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
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = ["en_US.UTF-8/UTF-8"];

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
      enable = false;
      xkb = {
        layout = "us,ru";
        variant = "";
      };
    };
    # TODO: hide "udh" in sddm
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
    desktopManager.plasma6.enable = true;
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
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "google-chrome"
      "zoom"
    ];

  users.users.fiona = {
    isNormalUser = true;
    description = "Fiona";
    extraGroups = ["networkmanager" "disk" "audio" "dialout" "video" "input"];
    packages = with pkgs; [
      google-chrome
      hunspell
      hunspellDicts.en_US
      kdePackages.kate
      kdePackages.kolourpaint
      libreoffice
      p7zip
      pandoc
      pdfchain
      thunderbird
      vlc
      zoom-us
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
  environment.systemPackages = with pkgs; [
    htop
    wget
    vim
  ];

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
  services.networkd-dispatcher = {
    enable = true;
    rules."restart-tor" = {
      onState = ["routable" "off"];
      script = ''
        #!${pkgs.runtimeShell}
        #if [[ $IFACE == "wlp3s0" && $AdministrativeState == "configured" ]]; then
          echo "Restarting Tor ..."
          systemctl restart tor
        #fi
        exit 0
      '';
    };
  };
}
