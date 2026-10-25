{ config, pkgs, ... }: {
  programs.axolotl-launcher = {
    enable = true;
    jres = with pkgs; [
      temurin-jre-bin-8
      temurin-jre-bin-11
      temurin-jre-bin-17
      temurin-jre-bin-21
      temurin-jre-bin-25
    ];
    launchEnv = {
      __EGL_EXTERNAL_PLATFORM_CONFIG_DIRS = "/run/opengl-driver/share/egl/egl_external_platform.d";
    };
  };
}
