{ ... }: {
  programs.mpv = {
    enable = true;
    # extraInput keeps the grouping comments of bindings.nix, which the
    # alphabetically rendered bindings option would drop.
    extraInput = import ./bindings.nix { };
    config = import ./config.nix { };
  };
}
