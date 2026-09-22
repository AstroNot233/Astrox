{ ... }: {
  nix = {
    enable = true;
    channel.enable = true;
    checkAllErrors = true;
    checkConfig = true;
    daemonUser = "root";
    extraOptions = "";
  };
}
