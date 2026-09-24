{ hostPlatform, pkgs, ... }: {
  nixpkgs = {
    hostPlatform = hostPlatform;
    config = {
      allowUnfree = true;
    };
    overlays = [ ];
  };
}
