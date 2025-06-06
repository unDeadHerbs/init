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
  boot.loader.grub.splashImage = ../../bg/nix-wallpaper-mosaic-blue.png;

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
  i18n.defaultLocale = "uk_UA.UTF-8";
  i18n.supportedLocales = ["uk_UA.UTF-8/UTF-8" "ru_RU.UTF-8/UTF-8" "en_US.UTF-8/UTF-8"];

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  # X11
  services.xserver = {
    enable = true;
    xkb = {
      layout = "ru,us";
      variant = "";
    };
    displayManager.lightdm.enable = true;
    desktopManager.cinnamon.enable = true;
  };
  services.displayManager = {
    autoLogin.enable = true;
    autoLogin.user = "serhii";
  };
  services.picom.enable = true; # for transparency

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      # Add additional package names here
      "google-chrome"
    ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.serhii = {
    isNormalUser = true;
    description = "Serhii";
    extraGroups = ["networkmanager"];
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
  security.sudo.wheelNeedsPassword = false;

  # Allow xfce4-terminal to have a settings file.
  programs.xfconf.enable = true;

  # Install some core programs.
  programs.zsh.enable = true;
  programs.firefox.enable = true;
  programs.mosh.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    htop
    wget
    vim
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Allow unfree packages
  # nixpkgs.config.allowUnfree = true;

  # List services that you want to enable:

  # Setup Remote Administration
  services.openssh = {
    enable = true;
    settings.X11Forwarding = true;
    settings.PasswordAuthentication = false;
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
