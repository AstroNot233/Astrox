{ ... }: {
  programs.helix = {
    enable = true;
    settings = import ./settings.nix {};
    themes = import ./themes.nix {};
  };
}
