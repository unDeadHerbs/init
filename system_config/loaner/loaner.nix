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
  boot = {
    loader = {
      # Menuing System
      grub = {
        enable = true;
        device = "/dev/sda";
        useOSProber = true;
        splashImage = ../../bg/nix-wallpaper-mosaic-blue.png;
      };
      # Hide the OS choice for bootloaders.
      # It's still possible to open the bootloader list by pressing any key
      # It will just not appear on screen unless a key is pressed
      timeout = 0;
    };
    # Splash Screen (TODO: probably set a theme?)
    plymouth.enable = true;
    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
    # Start faster (at the cost of a little space)
    initrd.systemd.enable = true;
    # Enable windows filesystm support
    supportedFilesystems = ["ntfs"];
  };

  # Enable networking
  networking.networkmanager.enable = true;
  # Network Discovery
  #services.avahi = {
  #  enable = true;
  #  publish.enable = true;
  #  publish.workstation = true;
  #  publish.userServices = true;
  #};

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
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

  # Graphical System
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
    displayManager.lightdm.enable = true;
    desktopManager.cinnamon.enable = true;
  };
  services.picom.enable = true; # for transparency support

  # Extra font support
  fonts.packages = with pkgs; [
    fira
    fira-code
  ];

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

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      # Add additional package names here
      "google-chrome"
    ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel"];
    #shell = pkgs.zsh;
    packages = with pkgs; [
      #moreutils cpufrequtils binutils usbutils
      #sh-z sicp inetutils xpdf
      alejandra
      evince
      google-chrome
    ];
  };
  programs.firefox.enable = true;

  # Allow xfce4-terminal to have a settings file.
  programs.xfconf.enable = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.X11Forwarding = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  system.autoUpgrade.enable = true; # periodically execute systemd service nixos-upgrade.service
  system.autoUpgrade.allowReboot = false; # If false, run nixos-rebuild switch --upgrade
}
