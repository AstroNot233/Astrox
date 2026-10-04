{
  lib,
  pkgs,
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
      # KeePassXC owns the password store, so every built-in entry point goes:
      # no manager, no save prompt, no address or payment autofill, no reveal.
      PasswordManagerEnabled = false;
      OfferToSaveLogins = false;
      DisablePasswordReveal = true;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      # The policy is an enum, not a boolean. "allowed" keeps HTTPS-Only Mode off
      # by default, which is what local services on 127.0.0.1 without HTTPS need,
      # and still leaves the switch available in settings; "disallowed" removes it.
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
      # Enabled = false already turns every generative AI feature off; the
      # per-feature keys are spelled out so the set stays visible in place.
      GenerativeAI = {
        Enabled = false;
        Chatbot = false;
        SmartWindow = false;
        LinkPreviews = false;
        TabGroups = false;
      };
      # "blocked" on Default covers every key AIControls lists; the per-feature
      # keys exist only to override it, so they stay unset.
      AIControls.Default = {
        Value = "blocked";
      };
      # Firefox 153 and later fetch from addons.mozilla.org by ID, so no
      # install_url is needed; force_installed keeps it updated as well.
      ExtensionSettings."tridactyl.vim@cmcaine.co.uk" = {
        installation_mode = "force_installed";
      };
    };
    nativeMessagingHosts = {
      packages = with pkgs; [
        tridactyl-native
      ];
    };
  };
}
