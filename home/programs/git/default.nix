{ ... }: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    signing = {
      format = "ssh";
      key = "/sync/Security/SSH/ed25519/astrox.pub";
      signByDefault = true;
    };
    settings = {
      user = {
        name = "AstroNot233";
        email = "tyz.err.233@gmail.com";
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
}
