{ ... }: {
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    recommendedServices.enable = true;
  };
}
