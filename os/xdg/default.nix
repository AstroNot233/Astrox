{ pkgs, ... }: {
  xdg = {
    portal = {
      # niri ships niri-portals.conf, which is read before any global portals.conf;
      # a global default=gtk would also pin ScreenCast to a backend without it.
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];
    };
  };
}
