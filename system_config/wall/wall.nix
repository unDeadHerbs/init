# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  ...
}: with lib; let
  unstable = import <nixos-unstable> {config = {allowUnfree = true;};};
in {
  options.per_system_config = {
    auto_login_user = lib.mkOption {
      type = types.str;
      default = "reiko";
      description = "Name of default user";
    };
  };
  imports = [
    ../nix/common.nix
    ../nix/desk.nix
    ../nix/user-udh.nix
  ];
  config={
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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

  # Enable sudo without having a user password
  security.sudo.wheelNeedsPassword = false;

  # Install core programs
  programs.zsh.enable = true;
  programs.mosh.enable = true;
  programs.firefox.enable = true;

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
  };
}
