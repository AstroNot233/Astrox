{ ... }: {
  programs.starship = {
    enable = true;
    extraPackages = [];
    enableBashIntegration = true;
    enableNushellIntegration = true;
    presets = [
      "gruvbox-rainbow"
    ];
    settings = {};
  };
}
