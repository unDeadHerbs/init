{
  config,
  pkgs,
  lib,
  ...
}: with lib; let
  # sudo nix-channel --add https://channels.nixos.org/nixos-unstable nixos-unstable
  # sudo nix-channel --update
  unstable = import <nixos-unstable> {config = {allowUnfree = true;};};
  #hostname_from_uuid = pkgs.runCommand "hostname-from-uuid.nix" {} ''
  #  echo "{ }: in { networking.hostname = \"$(${pkgs.dmidecode}/bin/dmidecode | ${pkgs.gnused}/bin/sed -n 's/.*UUID: //p' | head -n1)\";}" > $out
  #'';
  #  host_uuid = builtins.readFile host_uuid_file;
  #host_uuid_drv = pkgs.runCommandLocal "hostUuidFile" {} ''
#${pkgs.dmidecode}/bin/dmidecode | ${pkgs.gnused}/bin/sed -n 's/.*UUID: //p' | head -n1 > $out
#'';
  #host_uuid = builtins.readFile "${host_uuid_drv}" + "include ...";
in {
  imports = [
    #hostname_from_uuid
    #pkgs.runCommand "hostname-from-uuid.nix" {} ''
    #echo "{ }: in { networking.hostname = \"$(${pkgs.dmidecode}/bin/dmidecode | ${pkgs.gnused}/bin/sed -n 's/.*UUID: //p' | head -n1)\";}" > $out
  #''
  ];
    config={
  environment.systemPackages = with pkgs; [
    dmidecode
    gnused
  ];

  #networking.hostName = "loaner-" + pkgs.writeShellScriptBin "gen-conf" '' dmidecode | grep UUID | sed 's/.*: //' | head -1 | grep . '' ;
  
  #networking.hostName = "loaner-" + device_uid ;
  
  #networking.hostName = "loaner-" + lib.stringAfter [ ] ''
  #${pkgs.dmidecode}/bin/dmidecode | grep UUID | sed 's/.*: //'
  #'';

  #networking.hostName = "loaner-" + (builtins.readFile (pkgs.runCommand "aaaa_a_name" {
  #nativeBuildInputs = [ pkgs.dmidecode pkgs.gnugrep pkgs.gnused];
  #} ''
  #dmidecode | grep UUID | sed 's/.*: //'
  #''));

  #networking.hostName = "loaner-" + (builtins.readFile (pkgs.runCommand "system_uid" {
  #} (pkgs.writeShellApplication {
  #  name = "get_system_uid";
  #  runtimeInputs = [
  #    pkgs.dmidecode pkgs.gnugrep
  #      pkgs.gnused
  #  ];
  #  text = ''
  #dmidecode | grep UUID | sed 's/.*: //' > $out
  #'';
  #})));

  #networking.hostName = "loaner-" + host_uuid;

  #systemd.services.set-hostname-from-uuid = {
  #  description = "Set hostname from DMI UUID";
  #  wantedBy = [ "multi-user.target" ];
  #  serviceConfig.Type = "oneshot";
  #  script = ''
  #    if [ -f /sys/class/dmi/id/product_uuid ]; then
  #      hostnamectl set-hostname "loaner-$(cat /sys/class/dmi/id/product_uuid)"
  #    fi
  #  '';
  #};

  #services.hostnamed.enable = false;
  #systemd.services.set-hostname-from-uuid = {
  #  description = "Set hostname from DMI UUID";
  #  before = [ "network-pre.target" ];
  #  wantedBy = [ "network-pre.target" ];
  #  serviceConfig = {
  #    Type = "oneshot";
  #  };
  #  script = ''
  #    if [ -f /sys/class/dmi/id/product_uuid ]; then
  #      echo "loaner-$(cat /sys/class/dmi/id/product_uuid)" > /proc/sys/kernel/hostname
  #    fi
  #  '';
  #};

  #networking.hostName = "loaner-"+
  #  builtins.replaceStrings ["\n"] [""]
  #    (builtins.readFile "/sys/class/dmi/id/product_uuid");

  #networking.hostName = "loaner-" +
  #                      builtins.replaceStrings ["\n"] [""]
  #                        (builtins.readFile "/sys/class/dmi/id/product_uuid");

  networking.hostName = "loaner-01924d9f-5e50-cb11-80bf-9506f3c967c0";
  };
}
