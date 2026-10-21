{ pkgs, ... }: {
  programs.niri = {
    enable = true;
    # Backport of niri-wm/niri#1791 (SHM screen sharing): 26.04 is DMA-BUF only,
    # which Tencent Meeting cannot negotiate.
    package = pkgs.niri.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [ ./support-shm-sharing.patch ];
    });
    useNautilus = false;
  };
}
