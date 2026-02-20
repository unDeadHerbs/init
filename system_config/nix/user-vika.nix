{
  config,
  pkgs,
  lib,
  ...
}: let
  unstable = import <nixos-unstable> {config = {allowUnfree = true;};};
in {
  services.xserver.xkb = {
        layout = "us,ru";
        variant = "";
      };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) (
      [
        "google-chrome"
        #"vscode"
        "zoom"
      ]
    );

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vika = {
    isNormalUser = true;
    description = "Viktoriia";
    extraGroups = ["networkmanager" "disk" "audio" "dialout" "video" "input"]; 
    packages = with pkgs;
      [
      anki
      google-chrome
      ffmpeg
      hunspell
      hunspellDicts.uk_UA
      hunspellDicts.en_US
      kdePackages.kate
      kdePackages.kdenlive
      kdePackages.kolourpaint
      krita
      libreoffice
      obs-studio
      p7zip
      pandoc
      pdfchain
      (python311.withPackages (ps:
        with ps; [
          ipykernel
          jupyter
          jupyterlab
          matplotlib
          notebook
          numpy
          pandas
          pip
          scikit-learn
          scipy
          statsmodels
        ]))
      #R
      #rstudio
      #spyder # qt bug
      thunderbird
      vlc
      #vscode
      #zoom-us
      ];
  };
}
