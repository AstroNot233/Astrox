{ ... }: {
  imports = [
    ./avahi.nix
    ./flatpak.nix
    ./greetd.nix
    ./input-remapper.nix
    ./miscellaneous.nix
    ./networking.nix
    ./printing.nix
    ./sunshine.nix
    ./syncthing.nix
    ./xserver.nix
  ];
}
