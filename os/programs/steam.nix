{ pkgs, ... }: {
  programs.steam = {
    enable = true;
    fontPackages = [ pkgs.noto-fonts-cjk-sans ];
    protontricks.enable = true;
  };
}
