{ ... }: {
  services.xserver = {
    videoDrivers = [ "nvidia" ];
    xkb = {
      layout = "us,us";
      # Colemak first; Super+Space switches to QWERTY as an emergency way out.
      variant = "colemak,";
      options = "grp:win_space_toggle,caps:escape_shifted_capslock";
    };
  };
}
