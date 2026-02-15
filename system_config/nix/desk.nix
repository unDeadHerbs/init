# Computers that I can see the monitor of from my desk.
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
  # Enable networking
  services.avahi = {
    enable = true;
    publish.enable = true;
    publish.workstation = true;
    publish.userServices = true;
  };

  environment.systemPackages = with pkgs; [
    deskflow
  ];

  # Enable deskflow
  systemd.services.deskflow = {
    wantedBy = ["graphical.target"];
    after = ["network.target"];
    description = "Start the deskflow client for the default user.";
    serviceConfig = {
      Type = "simple";
      User = config.per_system_config.auto_login_user;
      ExecStart = ''${pkgs.deskflow}/bin/deskflow-core client -f --restart 192.168.0.31'';
      ExecStop = ''${pkgs.procps}/bin/pkill deskflow-core'';
    };
  };
}
