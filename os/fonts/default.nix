{ pkgs, plangothic, hostPlatform, ... }: {
  fonts = {
    enableDefaultPackages = false;
    enableGhostscriptFonts = false;
    fontDir.enable = true;
    packages = with pkgs; [
      corefonts
      source-han-sans
      source-han-serif
      noto-fonts
      noto-fonts-color-emoji
      plangothic.packages.${hostPlatform}.default
      jetbrains-mono
      nerd-fonts.symbols-only
    ];
    fontconfig = {
      defaultFonts = {
        emoji = [
          "Noto Color Emoji"
        ];
        monospace = [
          "JetBrains Mono"
          "Symbols Nerd Font Mono"
        ];
        sansSerif = [
          "Source Han Sans SC"
          "Plangothic P1"
          "Plangothic P2"
        ];
        serif = [
          "Source Han Serif SC"
        ];
      };
    };
  };
}
