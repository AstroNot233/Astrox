{ hostPlatform, ... }: {
  nixpkgs = {
    hostPlatform = hostPlatform;
    config = {
      allowUnfree = true;
    };
    overlays = [ ];
  };
}
