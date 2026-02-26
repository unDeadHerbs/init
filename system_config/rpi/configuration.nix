{
  config,
  pkgs,
  options,
  ...
}: let
  system_type = "rpi";
in {
  imports = [
    /etc/nixos/hardware-configuration.nix
    (/home/udh/init/system_config + "/${system_type}/${system_type}.nix")
  ];
}
