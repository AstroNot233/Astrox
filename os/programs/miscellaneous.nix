{ ... }: {
  programs = {
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    appimage = {
      enable = true;
      binfmt = true;
    };
  };
}
