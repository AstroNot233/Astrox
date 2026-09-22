{ lib, ... }: {
  xdg.configFile."niri".source = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.difference ./. ./default.nix;
  };
}
