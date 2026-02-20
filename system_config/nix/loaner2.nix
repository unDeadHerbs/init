#let
#pkgs = import <nixpkgs> {};
#
#  ifd = pkgs.runCommand "generated-hostname-from-uuid.nix" {} ''
#    echo "{ config, pkgs, ... }: { networking.hostName = \"$(${pkgs.dmidecode}/bin/dmidecode | ${pkgs.gnused}/bin/sed -n 's/.*UUID: //p' | head -n1)\";}" > $out
#'';
#in
##pkgs.callPackage (ifd) {}
#{...}:{
#  imports = [
#    ifd
#  ];
#}

#{ config, pkgs, lib, ... }:
#
#let
#  # IFD (Import From Derivation): generate a nix file containing hostname config
#  generatedHostConfig =
#    import
#      (pkgs.runCommand "generated-hostname-config" { buildInputs = [ pkgs.dmidecode pkgs.gnused ]; } ''
#        UUID="$(${pkgs.dmidecode}/bin/dmidecode \
#          | ${pkgs.gnused}/bin/sed -n 's/.*UUID: //p' \
#          | head -n1)"
#        mkdir -p $out
#        cat > $out/default.nix <<EOF
#{ ... }:
#{
#  networking.hostName = "loaner-$UUID";
#}
#EOF
#      '');
#in
#{
#  imports = [
#    generatedHostConfig
#  ];
#}


##{ config, pkgs, ... }: 
#let
#  #pkgs = import <nixpkgs> {};
#  drv = derivation {
#    name = "hello";
#    builder = "/bin/sh";
#    #args = [ "-c" ''echo "{ config, pkgs, ... }: { networking.hostName = \"$(dmidecode | sed -n 's/.*UUID: //p' | head -n1)\";}" > $out'' ];
#    args = [ "-c" ''echo "{ networking.hostName = \"$(dmidecode | sed -n 's/.*UUID: //p' | head -n1)\"";} > $out'' ];
#    system = builtins.currentSystem;
#  };
#in (builtins.readFile drv)


#let
#  drv = derivation {
#    name = "hello";
#    builder = "/bin/sh";
#    args = [ "-c" ''echo "{ networking.hostName = \"$(dmidecode | sed -n 's/.*UUID: //p' | head -n1);}}\"" > $out'' ];
#    system = builtins.currentSystem;
#  };
#in builtins.readFile drv


let
  drv = derivation {
    name = "hello";
    builder = "/bin/sh";
    args = [ "-c" ''echo "{ networking.hostName = \"$(cat /sys/class/dmi/id/product_uuid);}}\"" > $out'' ];
    system = builtins.currentSystem;
  };
in builtins.readFile drv
