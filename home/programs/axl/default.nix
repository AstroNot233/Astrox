{ pkgs, ... }: {
  programs.axolotl-launcher = {
    enable = true;
    launchEnv = {
      WEBKIT_DISABLE_DMABUF_RENDERER = 0;
    };
    jres = with pkgs; [
      jdk8
      jdk11
      jdk17
      jdk21
      jdk25
    ];
  };
}
