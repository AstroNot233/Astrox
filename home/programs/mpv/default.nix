{ ... }: {
  programs.mpv = {
    enable = true;
    # extraInput keeps bindings.nix's grouping comments; the bindings option drops them.
    extraInput = import ./bindings.nix { };
    config = import ./config.nix { };
  };
}
