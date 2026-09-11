# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  ...
}: {
  options.per_system_config = {
    full_udh_account = lib.mkOption {default = true;};
    tui_not_gui_system = lib.mkOption {default = true;};
    boot_loader = lib.mkOption {default = "extlinux";};
    quiet_boot = lib.mkOption {default = false;};
    gui_system = lib.mkOption {default = "tui";};
  };
  imports = [
    ../nix/common.nix
    ../nix/desk.nix
    ../nix/user-udh.nix
  ];
  config = {
    # The Pi is a bit small, so tasks taking a while isn't concerning.
    boot.kernel.sysctl = {
      "kernel.hung_task_timeout_secs" = 0;
    };

    nix.buildMachines = [{
      hostName = "udh@192.168.0.42";
      systems = [ "x86_64-linux" "aarch64-linux" ]; # Specify the architectures it supports
      # other options like maxJobs, supportedFeatures can be added here
    }];
    nix.distributedBuilds = true;
    nix.settings.max-jobs = 0;
    nix.settings.builders-use-substitutes = true;

    networking.hostName = "pi-wall"; # Define your hostname.

    # Pick only one of the below networking options.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

    swapDevices = [
      {
        device = "/swapfile";
        size = 4 * 1024; # 4GB
      }
    ];

    users.users.reiko = {
      isNormalUser = true;
      description = "reiko";
      extraGroups = ["networkmanager"];
      packages = with pkgs; [
      ];
    };

    security.sudo.wheelNeedsPassword = false;

    system.stateVersion = "25.11";

    # TODO: Setup Unifi Controller
    #nixpkgs.config.allowUnfreePredicate = pkg:
    #  builtins.elem (lib.getName pkg) ["unifi-controller"];
    #environment.systemPackages = with pkgs; [unifi];
  };
}
