{ ... }: {
  imports = [
    ./inputMethod.nix
  ];
  i18n = {
    defaultCharset = "UTF-8";
    defaultLocale = "en_US.UTF-8";
    extraLocales = [
      "zh_CN.UTF-8/UTF-8"
      "zh_TW.UTF-8/UTF-8"
    ];
    extraLocaleSettings = { };
    imperativeLocale = false;
    localeCharsets = { };
  };
}
