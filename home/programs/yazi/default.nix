{ ... }: {
  programs.yazi= {
    enable = true;
    initLua = ./init.lua;
    plugins = {};
    flavors = {};
    settings = {
      keymap = import ./keymap.nix {};
      theme  = import ./theme.nix {};
      vfs    = import ./vfs.nix {};
      yazi   = import ./yazi.nix {};
    };
  };
}
