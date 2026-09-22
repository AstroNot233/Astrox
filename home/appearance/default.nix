{ pkgs, ... }: {
  imports = [
    ./gtk.nix
    ./qt.nix
  ];
  xdg.dataFile = {
    "icons/default".source = "${pkgs.bibata-cursors}/share/icons/Bibata-Modern-Ice";
  };
}
