{ lib, ... }:
let
  defaultPrefs = {
    "permissions.default.shortcuts" = 0;
    "ui.key.menuAccessKeyFocuses" = false;
    "accessibility.typeaheadfind.manual" = false;
    "browser.backspace_action" = 2;
  };

  defaultPrefsJs = lib.concatMapAttrsStringSep "\n" (
    name: value: "defaultPref(${builtins.toJSON name}, ${builtins.toJSON value});"
  ) defaultPrefs;

  observerJs = ''
    const { classes: Cc, interfaces: Ci, results: Cr } = Components;
    const dropShortcuts = {
      observe(subject, topic) {
        const doc = topic === "chrome-document-loaded" ? subject : subject?.document;
        if (!doc || doc.documentElement?.getAttribute("id") !== "main-window") return;
        const keyset = doc.getElementById("mainKeyset");
        if (!keyset) return;
        for (const key of keyset.querySelectorAll("key")) {
          if (key.getAttribute("internal") === "true") continue;
          if (SHORTCUTS_TO_KEEP.has(key.id)) continue;
          key.removeAttribute("key");
          key.removeAttribute("keycode");
          key.setAttribute("disabled", "true");
        }
      },
      QueryInterface(iid) {
        if (iid.equals(Ci.nsIObserver) || iid.equals(Ci.nsISupports)) return this;
        throw Cr.NS_NOINTERFACE;
      },
    };
    const observerService = Cc["@mozilla.org/observer-service;1"].getService(
      Ci.nsIObserverService,
    );
    observerService.addObserver(dropShortcuts, "chrome-document-loaded");
    observerService.addObserver(dropShortcuts, "browser-delayed-startup-finished");
  '';
in
lib.concatStringsSep "\n" [
  defaultPrefsJs
  observerJs
]
