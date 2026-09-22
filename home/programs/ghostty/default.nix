{ pkgs, ... }: {
  programs.ghostty = {
    enable = true;
    clearDefaultKeybinds = true;
    settings = import ./settings.nix {};
    themes = import ./themes.nix {};
  };
}
