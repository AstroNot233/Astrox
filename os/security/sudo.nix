{ pkgs, ... }: {
  # Use sudo-rs instead of sudo.
  security.sudo.enable = false;
  security.sudo-rs = {
    enable = true;
    defaultOptions = [ "SETENV" ];
    extraConfig = ''
      Defaults editor=EDITOR
      Defaults env_keep+=EDITOR
    '';
  };
}
