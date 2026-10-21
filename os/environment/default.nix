{
  home-manager,
  hostPlatform,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./alsa-card-profile.nix
  ];
  environment = {
    defaultPackages = lib.mkForce [ ];
    systemPackages = builtins.concatLists [
      [ home-manager.packages.${hostPlatform}.home-manager ]
      (with pkgs; [
        wl-clipboard
        vial
        gnumake
        busybox
        ntfs3g
        android-tools
        xwayland-satellite
        kdePackages.breeze
        kdePackages.dolphin
        ddcutil
      ])
    ];
    variables = {
      LD_LIBRARY_PATH = "/run/opengl-driver/lib";
      EDITOR = "hx";
      VISUAL = "hx";
    };
  };
}
