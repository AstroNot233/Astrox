{ ... }: {
  services.xserver = {
    videoDrivers = [ "nvidia" ];
    xkb = {
      layout = "us";
      variant = "";
      options = "";
    };
  };
}
