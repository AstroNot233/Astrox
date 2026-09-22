{ pkgs, ... }: {
  fonts = {
  	enableDefaultPackages = false;
  	enableGhostscriptFonts = false;
  	fontDir.enable = true;
  	packages = with pkgs; [
  	  corefonts
  	  source-han-sans
  	  source-han-serif
  	  noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      jetbrains-mono
      nerd-fonts.symbols-only
  	];
  	fontconfig = {
      defaultFonts = {
        emoji = [
          "Noto Color Emoji"
          "Symbols Nerd Font"
        ];
        monospace = [
          "JetBrains Mono"
          "Noto Sans Mono CJK SC"
          "Symbols Nerd Font Mono"
        ];
        sansSerif = [
          "Noto Sans CJK SC"
          "Symbols Nerd Font"
        ];
        serif = [
          "Noto Serif CJK SC"
          "Symbols Nerd Font"
        ];
      };
    };
  };
}
