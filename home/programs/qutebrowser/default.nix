{ ... }: {
  programs.qutebrowser = {
    enable = true;
    aliases = {
      kill = "quit";
      q = "tab-close";
      t = "open --tab ";
      w = "open --window";
      window-new = "open --window";
    };
    enableDefaultBindings = false;
    # The upstream aliases qa/wq/wqa are dropped in extraConfig, which the
    # module emits after the aliases above.
    extraConfig = builtins.readFile ./extra.py;
    keyBindings = import ./keybindings.nix { };
    settings = import ./settings.nix { };
    searchEngines = rec {
      DEFAULT = b;
      b = "https://www.bing.com/search?q={}";
      d = "https://duckduckgo.com/?q={}";
      g = "https://www.google.com/search?q={}";
      no = "https://search.nixos.org/options?channel=unstable&query={}";
      np = "https://search.nixos.org/packages?channel=unstable&query={}";
      t = "https://www.tiger-code.com/search?query={}";
    };
  };
}
