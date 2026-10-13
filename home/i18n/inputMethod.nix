{ pkgs, ... }: {
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-gtk
        fcitx5-rime
        catppuccin-fcitx5
      ];
      waylandFrontend = true;
      systemd.enable = false;
      settings = {
        globalOptions = {
          Behavior = {
            ActiveByDefault = true;
            resetStateWhenFocusIn = "All";
            ShareInputState = "All";
            PreeditEnabledByDefault = false;
            ShowInputMethodInformation = false;
            DefaultPageSize = 10;
          };
          Hotkey = {
            ActivateKeys = "";
            DeactivateKeys = "";
            AltTriggerKeys = "";
            EnumerateGroupForwardKeys = "";
            EnumerateGroupBackwardKeys = "";
            PrevPage = "";
            NextPage = "";
            PrevCandidate = "";
            NextCandidate = "";
            TogglePreedit = "";
          };
          "Hotkey/TriggerKeys"."0" = "Alt+Shift+Shift_L";
        };
        inputMethod = {
          GroupOrder."0" = "Default";
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us-colemak";
            DefaultIM = "rime";
          };
          "Groups/0/Items/0".Name = "keyboard-us-colemak";
          "Groups/0/Items/1".Name = "rime";
        };
        addons = {
          classicui.globalSection = {
            "Vertical Candidate List" = true;
            WheelForPaging = false;
            Font = "Source Han Sans HW SC 13";
            MenuFont = "Symbols Nerd Font Mono 13";
            TrayFont = "Source Han Sans HW SC Bold 13";
            Theme = "catppuccin-latte-blue";
            DarkTheme = "catppuccin-mocha-blue";
            UseDarkTheme = true;
          };
          clipboard.globalSection = {
            TriggerKey = "";
            "Number of entries" = 0;
          };
          keyboard.globalSection = {
            PageSize = 10;
            PrevCandidate = "";
            NextCandidate = "";
            "Choose Modifier" = "None";
            "Hint Trigger" = "";
            "One Time Hint Trigger" = "";
            LongPressBlocklist = "";
          };
          quickphrase.globalSection = {
            TriggerKey = "";
            Spell = false;
          };
          rime.globalSection = {
            InputState = "Follow Global Configuration";
            PreeditCursorPositionAtBeginning = false;
          };
          unicode.globalSection = {
            TriggerKey = "";
            DirectUnicodeMode = "";
          };
          wayland.globalSection."Allow Overriding System XKB Settings" = false;
          xcb.globalSection."Allow Overriding System XKB Settings" = false;
        };
      };
    };
  };
}
