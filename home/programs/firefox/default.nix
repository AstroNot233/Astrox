{ pkgs, ... }: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      extraPrefs = builtins.readFile ./mozilla.cfg;
    };
    languagePacks = [
      "zh-CN"
      "zh-TW"
    ];
    policies = {
      DisableTelemetry = true;
    };
    nativeMessagingHosts = [
      pkgs.tridactyl-native
    ];
  };
}
