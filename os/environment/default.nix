{
  home-manager,
  hostPlatform,
  lib,
  pkgs,
  ...
}:
{
  environment = {
    defaultPackages = lib.mkForce [ ];
    systemPackages = builtins.concatLists [
      [ home-manager.packages.${hostPlatform}.home-manager ]
      (with pkgs; [
        wl-clipboard
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
      EDITOR = "hx";
      VISUAL = "hx";
    };
  };
}
