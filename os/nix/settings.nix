{ ... }: {
  nix.settings = {
    auto-optimise-store = false;
    cores = 0; # Auto select max value.
    max-jobs = "auto";
    require-sigs = true;
    sandbox = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "@wheel"
    ];
    extra-sandbox-paths = [
      "/dev"
      "/proc"
    ];
    substituters = [
      "https://nix-cache.bdot.in/"
      "https://mirrors.cernet.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"

      "https://nix-community.cachix.org"
      "https://axolotl-launcher-git.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "axolotl-launcher-git.cachix.org-1:6OBznZ1/jC7SRgugQ2PNGcy4VFyF0tDeWBMs2BPRt5Q="
    ];
  };
}
