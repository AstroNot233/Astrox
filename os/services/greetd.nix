{ pkgs, lib, ... }: {
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings = {
      default_session = {
        command = lib.strings.concatStringsSep " " [
          "${pkgs.tuigreet}/bin/tuigreet"
          "--time"
          "--issue"
          "--asterisks"
          "--remember"
          "--cmd niri-session"
        ];
        user = "greeter";
      };
    };
  };
}
