{ ... }: {
  imports = [
    ./avahi.nix
    ./flatpak.nix
    ./greetd.nix
    ./input-remapper.nix
    ./miscellaneous.nix
    ./networking.nix
    # ./ollama.nix
    ./printing.nix
    ./sunshine.nix
    ./syncthing.nix
    ./udev.nix
    ./xserver.nix
  ];
}
