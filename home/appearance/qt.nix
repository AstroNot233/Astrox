{ pkgs, ... }: {
  qt = {
    enable = true;
    platformTheme = {
      package = null;
      name = "gtk3";
    };
    style = {
      package = pkgs.adwaita-qt6;
      name = "adwaita";
    };
  };
}
