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
  unstable = import <nixos-unstable> {config = {allowUnfree = true;};};
in {
  options.per_system_config = {
    full_udh_account = lib.mkOption {default = false;};
    auto_login = lib.mkOption {default = true;};
    auto_login_account = lib.mkOption {default = "reiko";};
    boot_loader = lib.mkOption {default = "grub";};
    quiet_boot = lib.mkOption {default = false;};
    gui_system = lib.mkOption {default = "X";};
  };
  imports = [
    ../nix/common.nix
    ../nix/desk.nix
    ../nix/user-udh.nix
  ];
  config = {
    system.stateVersion = "25.11";

    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    # Display
    services.xserver = {
      enable = true;
      xrandrHeads = [
        {
          monitorConfig = "Option \"Rotate\" \"left\"";
          output = "VGA-1";
          primary = true;
        }
        # Disable the builtin screen
        {
          monitorConfig = "Option \"Ignore\" \"true\"";
          output = "LVDS-1";
        }
      ];
    };

    # UI
    services.xserver.windowManager.i3.enable = true;
    services.displayManager = {
      defaultSession = "none+i3";
      autoLogin.enable = config.per_system_config.auto_login;
      autoLogin.user = config.per_system_config.auto_login_account;
    };

    # Sound
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    users.users.reiko = {
      isNormalUser = true;
      description = "Reiko";
      extraGroups = ["networkmanager" "disk" "audio" "dialout" "video" "input"];
    };

    security.sudo.wheelNeedsPassword = false;

    # Install core programs
    programs.zsh.enable = true;
    programs.mosh.enable = true;
    programs.firefox.enable = true;

    # Kiosk Application
    systemd.services.firefoxKiosk = {
      wantedBy = ["default.target"];
      after = ["network.target"];
      wants = ["display-manager.service"];
      description = "Start firefox in kiosk mode.";
      serviceConfig = {
        Type = "simple";
        User = config.per_system_config.auto_login_account;
        Environment = "DISPLAY=:0"; # Needs to know where X is as it was started as a service
        ExecStart = ''${pkgs.firefox}/bin/firefox --kiosk'';
        ExecStop = ''${pkgs.procps}/bin/pkill firefox'';
        Restart = "always";
        RestartSec = "10";
      };
    };
  };
}
