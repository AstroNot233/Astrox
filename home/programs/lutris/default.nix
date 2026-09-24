{ pkgs, ... }: {
  programs.lutris = {
    enable = true;
    winePackages = [
      pkgs.winePackages.waylandFull
    ];
    protonPackages = [
      pkgs.proton-ge-bin
    ];
  };
}
