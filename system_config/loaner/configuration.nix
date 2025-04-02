{
  config,
  pkgs,
  options,
  ...
}: let
  # to alllow per-machine config
  hostname = "loaner";
  username = "username"; 
in {
  networking.hostName = hostname;

  imports = [
    /etc/nixos/hardware-configuration.nix
    (/home + "/${username}/init/system_config/${hostname}/${hostname}.nix")
  ];
}
