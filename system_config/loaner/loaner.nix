# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  ...
}: with lib; let
  # sudo nix-channel --add https://channels.nixos.org/nixos-unstable nixos-unstable
  # sudo nix-channel --update
  unstable = import <nixos-unstable> {config = {allowUnfree = true;};};
in {
  options.per_system_config = {
    primary_account = lib.mkOption {
      default = "udh";
    };
    auto_login = lib.mkOption{ default= false;};
    boot_grub_not_systemd = lib.mkOption{ default= true;};
  };
  imports = [
    ../nix/common.nix
    ../nix/desk.nix
    ../nix/user-udh.nix
  ];
  config={
    networking.hostName = "loaner";
    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "25.11"; # Did you read the comment?

    # Display
    services = {
      # TODO: hide "udh" in sddm
      displayManager.sddm.enable = true;
      displayManager.sddm.wayland.enable = true;
      desktopManager.plasma6.enable = true;
    };

    # Enable CUPS to print documents.
    services.printing.enable = true;
    services.printing.drivers = [pkgs.brlaser];

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

    # Enable sudo without having a user password
    security.sudo.wheelNeedsPassword = false;

    # Install core programs
    programs.zsh.enable = true;
    programs.mosh.enable = true;
    #programs.firefox.enable = true;
  };
}
