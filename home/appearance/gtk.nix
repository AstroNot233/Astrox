{ pkgs, ... }: {
  gtk = {
    enable = true;
    theme = {
      package = null;
      name = "Adwaita";
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus";
    };
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 32;
    };
    font = {
      package = null;
      name = "Source Han Sans SC";
      size = null;
    };
    colorScheme = null;
  };
}
