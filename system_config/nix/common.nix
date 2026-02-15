# Common config options for all of my systems.
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
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    useOSProber = true;
    splashImage = ../../bg/nix-wallpaper-mosaic-blue.png;
  };
  boot.supportedFilesystems = ["ntfs"];

  system.autoUpgrade = {
    enable = true; # periodically execute systemd service nixos-upgrade.service
    allowReboot = false; # If false, run nixos-rebuild switch --upgrade
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Enable networking
  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";
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

  fonts.packages = with pkgs; [
    fira
    fira-code
  ];

  environment.systemPackages = with pkgs; [
    htop
    wget
    vim
  ];

  # Setup Remote Administration
  services.openssh = {
    enable = true;
    #settings.X11Forwarding = true;
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
