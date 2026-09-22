{ pkgs, ... }: {
  programs.firefox = {
    enable = true;
    languagePacks = ["zh-CN" "zh-TW"];
    policies = {
      DisableTelemetry = true;
    };
    nativeMessagingHosts = [
      pkgs.tridactyl-native
    ];
  };
}
