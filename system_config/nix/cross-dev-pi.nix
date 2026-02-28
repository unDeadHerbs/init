{
  config,
  pkgs,
  lib,
  ...
}: {
  # Enable QEMU so it can execute ARM instructions.
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  # Define a package set for rPi: Allowing reference to
  # `pkgs.pkgsCross.aarch64-multiplatform` without flipping the global
  # 'nixpkgs.system' switch.
  nixpkgs.config.packageOverrides = pkgs: {
    rpiPkgs = import pkgs.path {
      crossSystem = lib.systems.examples.raspberryPi64;
      inherit (pkgs) config;
    };
  };
}
