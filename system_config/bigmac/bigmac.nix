# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  ...
}: {
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
  services.xserver.enable = true;
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };
  
  fonts.packages = with pkgs; [
    fira
    fira-code
  ];

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

  programs.zsh.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.vika = {
    isNormalUser = true;
    description = "vika";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };
  users.users.udh = {
    isNormalUser = true;
    description = "udh";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
    packages = with pkgs; [
      #moreutils cpufrequtils binutils usbutils
      #sh-z sicp inetutils xpdf
      alejandra
      aspell
      bat
      clang
      cowsay
      curl
      dmenu
      ed
      feh
      figlet
      git
      gnumake
      i3status
      libnotify
      links2
      lynx
      mc
      neofetch
      netcat
      pandoc
      progress
      scrot
      tmux
      unzip
      wdiff
      xfce.xfce4-terminal
      youtube-dl
      zsh-autosuggestions
    ];
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "vika";
  
  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Allow xfce4-terminal to have a settings file.
  programs.xfconf.enable = true;

  # Enable Barrier
  #systemd.services.barrierc = {
  #  # this is the "node" in the systemd dependency graph that will run the service
  #  wantedBy = ["graphical.target"];
  #  # systemd service unit declarations involve specifying dependencies and order of execution of systemd nodes
  #  after = ["network.target"];
  #  description = "Start the brarrier client for uDH.";
  #  serviceConfig = {
  #    # see systemd man pages for more information on the various options for "Type": "notify"
  #    # specifies that this is a service that waits for notification from its predecessor (declared in
  #    # `after=`) before starting
  #    Type = "simple";
  #    User = "udh";
  #    ExecStart = ''${pkgs.barrier}/bin/barrierc -f --restart --disable-crypto 192.168.0.15'';
  #    ExecStop = ''${pkgs.procps}/bin/pkill barrierc'';
  #  };
  #};
  #services.emacs.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    barrier
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

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  system.autoUpgrade.enable = true; # periodically execute systemd service nixos-upgrade.service
  system.autoUpgrade.allowReboot = false; # If false, run nixos-rebuild switch --upgrade
}
