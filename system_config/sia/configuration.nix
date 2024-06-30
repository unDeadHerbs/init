{
  config,
  pkgs,
  options,
  ...
}: let
  hostname = "sia"; # to alllow per-machine config
in {
  networking.hostName = hostname;

  imports = [
    /etc/nixos/hardware-configuration.nix
    (/home/udh/init/system_config + "/${hostname}/${hostname}.nix")
  ];
}
