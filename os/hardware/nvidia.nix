{ ... }: {
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement = {
      enable = true;
      # The laptop panel hangs off the only display controller (01:00.0), so
      # RTD3 offload cannot power the GPU down; no iGPU exists to offload from.
      finegrained = false;
    };
    open = true;
    nvidiaSettings = true;
  };
}
