{ ... }: {
  command = "nu";
  font-size = 12;
  font-feature = "calt=0,cv06,cv07,cv11,cv14";
  theme = "Catppuccin Dim";
  background-opacity = 1.0;
  scrollback-limit = 8192;
  window-theme = "ghostty";
  window-save-state = "never";

  keybind = [
    "shift+insert=paste_from_clipboard"
    "ctrl+insert=copy_to_clipboard"
  ];
}
