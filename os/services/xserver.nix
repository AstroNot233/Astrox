{ ... }: {
  services.xserver = {
    videoDrivers = [ "nvidia" ];
    xkb = {
      layout = "us,us";
      # Colemak first so a new session starts in it; Super+Space (grp:win_space_toggle)
      # switches to plain QWERTY, kept only as an emergency way out.
      variant = "colemak,";
      options = "grp:win_space_toggle,caps:escape_shifted_capslock";
    };
  };
}
