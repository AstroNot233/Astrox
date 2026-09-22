{ pkgs, ... }: {
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      efi = {
        efiSysMountPoint = "/efi";
        canTouchEfiVariables = true;
      };
      systemd-boot = {
        enable = true;
        consoleMode = "1";
        editor = false;
        edk2-uefi-shell = {
          enable = true;
          sortKey = "edk2-uefi-shell";
        };
      };
      timeout = 5;
    };
    extraModprobeConfig = ''
      options hid_apple fnmode=2
    '';
  };
}
