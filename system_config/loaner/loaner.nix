# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  # sudo nix-channel --add https://channels.nixos.org/nixos-unstable nixos-unstable
  # sudo nix-channel --update
  unstable = import <nixos-unstable> {config = {allowUnfree = true;};};
in {
  options.per_system_config = {
    full_udh_account = lib.mkOption {default = true;};
    auto_login = lib.mkOption {default = false;};
    boot_loader = lib.mkOption {default = "grub";};
    quiet_boot = lib.mkOption {default = true;};
    gui_system = lib.mkOption {default = "X";};
  };
  imports = [
    ../nix/common.nix
    ../nix/desk.nix
    ../nix/user-udh.nix
    ../nix/loaner.nix
    #../nix/loaner2.nix
  ];
  config = {
    system.stateVersion = "25.11";

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
