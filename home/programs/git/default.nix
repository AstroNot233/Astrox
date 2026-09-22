{ ... }: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        name = "Astronot233";
        email = "tyz.err.233@gmail.com";
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
}
