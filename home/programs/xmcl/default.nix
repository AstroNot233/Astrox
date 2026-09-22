{ pkgs, ... }: {
  programs.xmcl = {
    enable = true;
    jres = with pkgs; [
      jdk8
      jdk11
      jdk17
      jdk21
      jdk25
    ];
    launchEnv = {};
    launchArg = [
      "--no-sandbox"
      "--disable-dev-shm-usage"
      "--electron_ozone_platform_hint=auto"
    ];
  };
}
