{ pkgs, ... }: {
  i18n = {
    defaultCharset      = "UTF-8";
    defaultLocale       = "en_US.UTF-8";
    extraLocales        = [ "zh_CN.UTF-8/UTF-8" "zh_TW.UTF-8/UTF-8" ];
    extraLocaleSettings = {};
#   glibcLocales        = null;
    imperativeLocale    = false;
    localeCharsets      = {};
    inputMethod = {
      enable = true;
      type = "fcitx5";
      uim.toolbar = "gtk";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-gtk
          fcitx5-rime
        ];
      };
    };
  };
}
