{ pkgs, ... }: {
  programs.steam = {
    enable = true;
    fontPackages = [];
    extest.enable = true;
    gamescopeSession.enable = true;
    protontricks.enable = true;
  };
}
