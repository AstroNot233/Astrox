{ lib, ... }:
let
  bootstrapJs = ''
    const DSH_KEYSET_ID = "dsh-keyset";

    const dshRun = (win, action) => {
      try {
        if (DSH_ACTIONS[action]) return DSH_ACTIONS[action](win);
        win.goDoCommand(action);
      } catch (e) {
        Services.console.logStringMessage("dsh: key " + action + " failed: " + e);
      }
    };

    const dshAddKeyset = (win) => {
      const doc = win.document;
      const mainKeyset = doc.getElementById("mainKeyset");
      if (!mainKeyset || doc.getElementById(DSH_KEYSET_ID)) return;
      const NS = "http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul";

      const keyset = doc.createElementNS(NS, "keyset");
      keyset.setAttribute("id", DSH_KEYSET_ID);
      for (const binding of DSH_KEYS) {
        const key = doc.createElementNS(NS, "key");
        key.setAttribute("key", binding.key);
        if (binding.modifiers) key.setAttribute("modifiers", binding.modifiers);
        key.setAttribute("reserved", "true");
        key.addEventListener("command", () => dshRun(win, binding.action));
        keyset.appendChild(key);
      }
      mainKeyset.parentNode.insertBefore(keyset, mainKeyset);
    };

    const dshObserve = {
      observe(subject, topic) {
        const doc = topic === "chrome-document-loaded" ? subject : subject?.document;
        if (!doc || doc.documentElement?.getAttribute("id") !== "main-window") return;
        const keyset = doc.getElementById("mainKeyset");
        if (!keyset) return;

        // 只设 disabled，严禁摘元素或摘 key/keycode 属性：Firefox 初始化窗口时按 id
        // 取这些元素且无 null 保护，缺一个就打不开窗口。
        for (const key of keyset.querySelectorAll("key")) {
          key.setAttribute("disabled", "true");
        }
        dshAddKeyset(doc.defaultView);
      },
      QueryInterface(iid) {
        if (iid.equals(Ci.nsIObserver) || iid.equals(Ci.nsISupports)) return this;
        throw Cr.NS_NOINTERFACE;
      },
    };

    const dshObserverService = Cc["@mozilla.org/observer-service;1"].getService(
      Ci.nsIObserverService,
    );
    dshObserverService.addObserver(dshObserve, "chrome-document-loaded");
    dshObserverService.addObserver(dshObserve, "browser-delayed-startup-finished");
  '';
in
{
  inherit bootstrapJs;
}
