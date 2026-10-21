{
  lib,
  ...
}:
{
  programs.firefox = {
    enable = true;
    autoConfig = import ./autoConfig.nix { inherit lib; };
    languagePacks = [
      "zh-CN"
      "zh-TW"
    ];
    policies = {
      DisableTelemetry = true;
      # KeePassXC owns the password store.
      PasswordManagerEnabled = false;
      OfferToSaveLogins = false;
      DisablePasswordReveal = true;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      # Enum, not boolean: "allowed" leaves HTTPS-Only off, still switchable in settings.
      HttpsOnlyMode = "allowed";
      UserMessaging = {
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        UrlbarInterventions = false;
        SkipOnboarding = true;
        MoreFromMozilla = false;
        FirefoxLabs = false;
      };
      FirefoxHome = {
        Search = false;
        Weather = false;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        Stories = false;
        SponsoredPocket = false;
        SponsoredStories = false;
        Snippets = false;
        Widgets.Enabled = false;
      };
      # Enabled = false covers every AI feature; the keys stay for visibility.
      GenerativeAI = {
        Enabled = false;
        Chatbot = false;
        SmartWindow = false;
        LinkPreviews = false;
        TabGroups = false;
      };
      # Default covers every key AIControls lists; per-feature keys stay unset.
      AIControls.Default = {
        Value = "blocked";
      };
    };
  };
}
