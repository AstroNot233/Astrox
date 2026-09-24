{ ... }: {
  services.xserver = {
    videoDrivers = [ "nvidia" ];
    xkb = {
      layout = "us";
      options = "caps:escape_shifted_capslock";
    };
  };
}
