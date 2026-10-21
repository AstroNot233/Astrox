{ lib, ... }:
let
  bind =
    {
      key,
      modifiers ? null,
      action,
    }:
    {
      js = lib.generators.toJSON { } (
        { inherit key action; } // lib.optionalAttrs (modifiers != null) { inherit modifiers; }
      );
    };

  keys = [
    (bind {
      key = "x";
      modifiers = "alt";
      action = "dshCmdline";
    })
    (bind {
      key = "t";
      modifiers = "accel";
      action = "dshNewTab";
    })
    (bind {
      key = "t";
      modifiers = "accel,shift";
      action = "dshCloseTab";
    })
    (bind {
      key = "w";
      modifiers = "accel";
      action = "dshNewWindow";
    })
    (bind {
      key = "w";
      modifiers = "accel,shift";
      action = "dshCloseWindow";
    })
    (bind {
      key = "PageDown";
      modifiers = "accel";
      action = "dshNextTab";
    })
    (bind {
      key = "PageUp";
      modifiers = "accel";
      action = "dshPreviousTab";
    })
    (bind {
      key = "=";
      modifiers = "accel";
      action = "dshZoomIn";
    })
    (bind {
      key = "-";
      modifiers = "accel";
      action = "dshZoomOut";
    })
    (bind {
      key = "0";
      modifiers = "accel";
      action = "dshZoomReset";
    })
  ];
in
{
  # Actions must be functions: chrome CSP blocks win.eval and inline oncommand.
  actionsJs = ''
    const dshSelectTab = (win, step) => {
      const tabs = win.gBrowser.tabs;
      const current = tabs.indexOf(win.gBrowser.selectedTab);
      if (current < 0) return;
      win.gBrowser.selectedTab = tabs[(current + step + tabs.length) % tabs.length];
    };

    const DSH_ACTIONS = {
      dshCmdline: (win) => {
        win.gURLBar.focus();
        win.gURLBar.select();
      },
      dshNewTab: (win) =>
        win.gBrowser.addTab("about:newtab", {
          triggeringPrincipal: Services.scriptSecurityManager.getSystemPrincipal(),
        }),
      dshCloseTab: (win) => win.gBrowser.removeCurrentTab(),
      dshNewWindow: (win) =>
        win.openTrustedLinkIn("about:newtab", "window"),
      dshCloseWindow: (win) => win.close(),
      dshNextTab: (win) => dshSelectTab(win, 1),
      dshPreviousTab: (win) => dshSelectTab(win, -1),
      dshZoomIn: (win) => (win.ZoomManager.zoom *= 1.1),
      dshZoomOut: (win) => (win.ZoomManager.zoom /= 1.1),
      dshZoomReset: (win) => (win.ZoomManager.zoom = 1),
      dshFullScreen: (win) => (win.fullScreen = !win.fullScreen),
      dshPreferences: (win) => win.openTrustedLinkIn("about:preferences", "tab"),
      dshHelp: (win) =>
        win.openTrustedLinkIn(
          "https://support.mozilla.org/kb/keyboard-shortcuts-perform-firefox-tasks-quickly",
          "tab",
        ),
    };

    const DSH_KEYS = [
    ${lib.concatStringsSep "\n" (map (binding: "  ${binding.js},") keys)}
    ];
  '';
}
