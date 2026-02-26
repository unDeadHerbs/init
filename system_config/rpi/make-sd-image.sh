#!/usr/bin/env bash

set -e

nix-build '<nixpkgs/nixos>' -A config.system.build.sdImage -I nixos-config=./sd-image.nix --argstr system aarch64-linux
cp result/sd-image/nixos-image-sd-card-*zst .
nix-shell -p zstd --run "unzstd nixos-image-sd-card-*.zst"
rm result
rm -f nixos-image-sd-card-*.zst

