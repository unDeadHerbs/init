# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  nixpkgs,
  ...
}: {
  options.per_system_config = {
    full_udh_account = lib.mkOption {default = true;};
    auto_login = lib.mkOption {default = true;};
    auto_login_account = lib.mkOption {default = "udh";};

    multi_user = lib.mkOption {default = false;};
    # true -> common adds login page
    # false -> udh add i3

    boot_loader = lib.mkOption {default = "grub";};
    quiet_boot = lib.mkOption {default = false;};
    gui_system = lib.mkOption {default = "X";};
  };
  imports = [
    ../nix/common.nix
    ../nix/cross-dev-pi.nix
    ../nix/desk.nix
    ../nix/user-udh.nix
  ];
  config = {
    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "25.11"; # Did you read the comment?
    # sudo nix-channel --add https://channels.nixos.org/nixos-25.11 nixos
    # sudo nixos-rebuild switch --upgrade

    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };
    # X11
    services.xserver = {
      enable = true;
      xrandrHeads = [
        {
          monitorConfig = "Option \"Rotate\" \"left\"";
          output = "HDMI-1";
          primary = true;
        }
      ];
      # TODO: disable lightdm?
      displayManager.lightdm.enable = true;
    };

    services.xserver.windowManager.i3.enable = true;
    services.displayManager = {
      defaultSession = "none+i3";
      autoLogin.enable = config.per_system_config.auto_login;
      autoLogin.user = config.per_system_config.auto_login_account;
    };

    users.users.udh.packages = with pkgs;
      [
        anki-bin
         (anki.withAddons [
           ankiAddons.anki-connect
         ])
      ];

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Programs with extra config requirements
    programs.firefox.enable = true;

    # Enable sudo without having a user password
    security.sudo.wheelNeedsPassword = false;

    # List packages installed in system profile.
    environment.systemPackages = with pkgs; [
      nginx
      noip
    ];

    # Allow this machine to serve as a remote builder.
    nix.settings.trusted-users = ["root" "@wheel"];

    # Public Servers
    boot.enableContainers = true;
    virtualisation.containers.enable = true;
    networking.firewall.allowedTCPPorts = [80 443 8065];
    security.acme = {
      acceptTerms = true;
      defaults.email = "undeadherbs@gmail.com";
    };

    networking.nat = {
      enable = true;
      internalInterfaces = ["ve-+"];
      externalInterface = "eno1";
      # Lazy IPv6 connectivity for the container
      enableIPv6 = true;
    };
    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
    };

    # Webserver Container settings
    containers.RootWebServer = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.100.10";
      localAddress = "192.168.100.12";
      hostAddress6 = "fc00::1";
      localAddress6 = "fc00::2";
      config = {
        config,
        pkgs,
        lib,
        ...
      }: {
        services.httpd = {
          enable = true;
          adminAddr = "admin@udh.ddns.net";
        };

        networking = {
          firewall.allowedTCPPorts = [80];
          # Use systemd-resolved inside the container
          # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
          useHostResolvConf = lib.mkForce false;
        };

        services.resolved.enable = true;
        system.stateVersion = "25.11";
      };
    };

    services.nginx.virtualHosts."udh.ddns.net" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://192.168.100.12";
        proxyWebsockets = true;
      };
      locations."/robots.txt" = {
        extraConfig = ''
          rewrite ^/(.*)  $1;
          return 200 "User-agent: *\nDisallow: /";
        '';
      };
    };

    # Mattermost Test Server
    #containers.mattermostTestServer = {
    #  autoStart = true;
    #  privateNetwork = true;
    #  hostAddress = "192.168.100.10";
    #  localAddress = "192.168.100.13";
    #  hostAddress6 = "fc00::1";
    #  localAddress6 = "fc00::3";
    #  config = {
    #    config,
    #    pkgs,
    #    lib,
    #    ...
    #  }: {
    #    networking = {
    #      firewall.allowedTCPPorts = [8065];
    #      # Use systemd-resolved inside the container
    #      # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
    #      useHostResolvConf = lib.mkForce false;
    #    };
    #    services.resolved.enable = true;
    #    system.stateVersion = "25.11";
    #    environment.systemPackages = with pkgs; [mattermost];
    #    services.mattermost = {
    #      enable = true;
    #      siteUrl = "https://mmt.udh.ddns.net"; # Set this to the URL you will be hosting the site on.
    #      host = "0.0.0.0"; # Enable listing to host machine on VPN
    #    };
    #  };
    #};
    #services.nginx.virtualHosts."mmt.udh.ddns.net" = {
    #  forceSSL = true;
    #  enableACME = true;
    #  locations."/" = {
    #    proxyPass = "http://192.168.100.13:8065";
    #    proxyWebsockets = true;
    #  };
    #};

    # Mattermost CfR Server
    containers.mattermostCfRServer = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.100.10";
      localAddress = "192.168.100.14";
      hostAddress6 = "fc00::1";
      localAddress6 = "fc00::4";
      config = {
        config,
        pkgs,
        lib,
        ...
      }: let
        callPlugin = builtins.fetchurl {
          # Pinning to 0.29 because 1.0 moves group calls to a premium feature.
          # https://forum.mattermost.com/t/start-call-button-disappeared-after-v10-update/19538/5
          # Move to teamspeak once that's supported.
          url = "https://github.com/mattermost/mattermost-plugin-calls/releases/download/v0.29.2/mattermost-plugin-calls-v0.29.2.tar.gz";
          sha256 = "1pag2932pvxyjm728mggzy2hx7gapi7ib9wcyy8b03q47nsixmmk";
        };
      in {
        networking = {
          firewall.allowedTCPPorts = [8065];
          # Use systemd-resolved inside the container
          # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
          useHostResolvConf = lib.mkForce false;
        };
        services.resolved.enable = true;
        system.stateVersion = "25.11";
        environment.systemPackages = with pkgs; [mattermost];
        services.mattermost = {
          enable = true;
          siteUrl = "https://cfr.udh.ddns.net"; # Set this to the URL you will be hosting the site on.
          host = "0.0.0.0"; # Enable listing to host machine on VPN
          plugins = [
            callPlugin
          ];
        };
      };
    };
    services.nginx.virtualHosts."cfr.udh.ddns.net" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://192.168.100.14:8065";
        proxyWebsockets = true;
      };
    };

    # CfR Nextcloud Server
    #containers.nextcloudCfRServer = {
    #  autoStart = true;
    #  privateNetwork = true;
    #  hostAddress = "192.168.100.10";
    #  localAddress = "192.168.100.15";
    #  hostAddress6 = "fc00::1";
    #  localAddress6 = "fc00::5";
    #  config = {
    #    config,
    #    pkgs,
    #    lib,
    #    ...
    #  }: {
    #    networking = {
    #      firewall.allowedTCPPorts = [80];
    #      # Use systemd-resolved inside the container
    #      # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
    #      useHostResolvConf = lib.mkForce false;
    #    };
    #    services.resolved.enable = true;
    #    system.stateVersion = "25.11";
    #    #environment.systemPackages = with pkgs; [nextcloud];
    #    # TODO: Don't do this
    #    environment.etc."nextcloud-admin-pass".text = "PWD123456789";
    #    services.nextcloud = {
    #      enable = true;
    #      package = pkgs.nextcloud31;
    #      hostName = "localhost";
    #      config.adminpassFile = "/etc/nextcloud-admin-pass";
    #      config.dbtype = "sqlite";
    #      #settings.trusted_domains = ["sia.local"];
    #      #settings.trusted_domains = ["192.168.100.10"];
    #      settings.trusted_domains = ["192.168.100.15" "cfrnc.udh.ddns.net"];
    #    };
    #  };
    #};
    #services.nginx.virtualHosts."cfrnc.udh.ddns.net" = {
    #  forceSSL = true;
    #  enableACME = true;
    #  locations."/" = {
    #    proxyPass = "http://192.168.100.15";
    #    proxyWebsockets = true;
    #  };
    #};
    
    #containers.NIATM-jekyll = {
    #  autoStart = true;
    #  privateNetwork = true;
    #  hostAddress = "192.168.100.10";
    #  localAddress = "192.168.100.16";
    #  hostAddress6 = "fc00::1";
    #  localAddress6 = "fc00::6";
    #  # Bind the host folder to the container
    #  bindMounts = {
    #    "/srv/jekyll" = {
    #      hostPath = "/home/udh/NIATM_website";
    #      isReadOnly = false; # Jekyll to write to _site folder
    #    };
    #  };
    #  
    #  config = { pkgs, ... }: {
    #    environment.systemPackages = [ 
    #      pkgs.jekyll 
    #      pkgs.bundler 
    #    ];
    #    networking.firewall.allowedTCPPorts = [ 4000 ];
    #    systemd.services.jekyll-serve = {
    #      description = "Jekyll Service";
    #      wantedBy = [ "multi-user.target" ];
    #      after = [ "network.target" ];
    #      serviceConfig = {
    #        WorkingDirectory = "/srv/jekyll";
    #        #ExecStart = "${pkgs.jekyll}/bin/jekyll serve --host 0.0.0.0 --trace";
    #        ExecStart = "${pkgs.bundler}/bin/bundle exec jekyll serve --livereload -H 0.0.0.0 --trace";
    #        Restart = "always";
    #      };
    #    };
    #  };
    #};
    services.nginx.virtualHosts."niatm.udh.ddns.net" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://192.168.0.31:4000";
        proxyWebsockets = true;
      };
    };
  };
}
