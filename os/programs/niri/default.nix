{ pkgs, ... }: {
  programs.niri = {
    enable = true;
    # niri 26.04 casts through a DMA-BUF-only PipeWire stream, which the screen
    # sharing path of Tencent Meeting cannot negotiate (it ends up with zero
    # frames). Upstream added an SHM fallback after 26.04 in PR niri-wm/niri#1791;
    # carry the backport until nixpkgs ships a release that contains it.
    package = pkgs.niri.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [ ./support-shm-sharing.patch ];
    });
    useNautilus = false;
  };
}
