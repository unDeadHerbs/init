# Build with the following command
#
# nix-build '<nixpkgs/nixos>' -A config.system.build.sdImage -I nixos-config=./sd-image.nix --argstr system aarch64-linux
#
# - Mount the remote host
# - copy init over
# - sudo su
# - nix-channel --add https://channels.nixos.org/nixos-25.11 nixos
# - nix-channel --update
# - nixos-generate-config to make /etc/nixos/hardware-configuration.nix
# - copy the base config to /etc/nixos
# - nixos-rebuild --no-reexec switch --upgrade --build-host udh@sia.local
# # https://wiki.nixos.org/wiki/Nixos-rebuild#Deploying_on_a_different_architecture
{lib, ...}: {
  imports = [
    <nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64.nix>
    ./rpi.nix
  ];
  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  users.users.udh = {
    openssh.authorizedKeys.keys = lib.strings.splitString "\n" (builtins.readFile (
      builtins.fetchurl {
        url = "https://github.com/undeadherbs.keys";
        sha256 = "sha256:1ia4hca9zxmbh6yiapxc4mc1560sg9znghn5g9v08xnvhv99xq8n";
      }
    ));
  };
}
