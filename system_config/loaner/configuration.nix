{
  config,
  pkgs,
  options,
  ...
}: let
in {
  imports = [
    /etc/nixos/hardware-configuration.nix
    (/home + "/udh/init/system_config/loaner/loaner.nix")
  ];
}
