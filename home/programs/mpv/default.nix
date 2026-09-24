{ ... }: {
  programs.mpv = {
    enable = true;
    bindings = import ./bindings.nix { };
    config = import ./config.nix { };
  };
}
