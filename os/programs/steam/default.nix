{
  hostPlatform,
  plangothic,
  pkgs,
  ...
}:
{
  programs.steam = {
    enable = true;
    fontPackages = [
      pkgs.source-han-sans
      plangothic.packages.${hostPlatform}.default
    ];
    extest.enable = true;
    gamescopeSession.enable = true;
    protontricks.enable = true;
  };
}
