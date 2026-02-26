# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  # The Pi is a bit small, so tasks taking a while isn't concerning.
  boot.kernel.sysctl = {
    "kernel.hung_task_timeout_secs" = 0;
  };
  
  networking.hostName = "pi-wall"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  services.avahi = {
    enable = true;
    publish.enable = true;
    publish.workstation = true;
    publish.userServices = true;
  };
  
  swapDevices = [{
    device = "/swapfile";
    size = 4 * 1024; # 4GB
  }];
  
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
  
  # Enable the X11 windowing system.
  #services.xserver = {
  #  enable = true;
  #  xrandrHeads = [
  #    {
  #      monitorConfig = "Option \"Rotate\" \"left\"";
  #      output = "HDMI-1";
  #      primary = true;
  #    }
  #  ];
  #  xkb = {
  #    layout = "us";
  #    variant = "";
  #  };
  #  displayManager = {
  #    lightdm.enable = true;
  #  };
  #  windowManager.i3.enable = true;
  #};
  #services.displayManager = {
  #  defaultSession = "none+i3";
  #  autoLogin.enable = true;
  #  autoLogin.user = "reiko";
  #};

  programs.zsh.enable = true;
  users.users.reiko = {
    isNormalUser = true;
    description = "reiko";
    extraGroups = ["networkmanager" "wheel"];
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
      neofetch
      netcat
    ];
  };

  # Install firefox.
  #programs.firefox.enable = true;
  # firefox kiosk
  #systemd.services.firefox = {
  #  # this is the "node" in the systemd dependency graph that will run the service
  #  wantedBy = [];
  #  # systemd service unit declarations involve specifying dependencies and order of execution of systemd nodes
  #  after = ["graphical.target"];
  #  description = "Start the firefox kiosk for reiko.";
  #  serviceConfig = {
  #    # see systemd man pages for more information on the various options for "Type": "notify"
  #    # specifies that this is a service that waits for notification from its predecessor (declared in
  #    # `after=`) before starting
  #    Type = "simple";
  #    User = "reiko";
  #    ExecStart = ''${pkgs.firefox}/bin/firefox --kiosk'';
  #    ExecStop = ''${pkgs.procps}/bin/pkill firefox'';
  #  };
  #};
  
  environment.systemPackages = with pkgs; [
    # barrier
    htop
    wget
    vim
    git
  ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "25.11";
}

