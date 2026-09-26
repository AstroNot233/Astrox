{
  assets,
  pkgs,
  ...
}:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      efi = {
        efiSysMountPoint = "/boot";
        canTouchEfiVariables = true;
      };
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        gfxmodeEfi = "auto";
        extraConfig = ''
          if [ ! "$main" ]; then
            configfile /theme/main.cfg
          fi
        '';
        extraEntries = ''
          menuentry "Main Menu" {
            configfile /theme/main.cfg
          }
        '';
        theme = assets."Minegrub";
      };
      timeout = 5;
    };
    extraModprobeConfig = ''
      options hid_apple fnmode=2
    '';
  };
}
