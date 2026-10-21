{ ... }: {
  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    libinput.enable = true;
    openssh.enable = true;
    power-profiles-daemon.enable = true;
    upower.enable = true;
  };
}
