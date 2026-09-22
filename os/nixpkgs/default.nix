{ pkgs, hostPlatform, ... }: {
  nixpkgs = {
    hostPlatform = hostPlatform;
    config = {
      allowUnfree = true;
    };
    overlays = [
      (final: prev: {
        librime = (
          prev.librime.override {
            plugins = with pkgs; [
              librime-lua
              librime-octagram
            ];
          }
        ).overrideAttrs (old: {
          buildInputs = (old.buildInputs or []) ++ [ pkgs.luajit ];
        });
      })
    ];
  };
}
