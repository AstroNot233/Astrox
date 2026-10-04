{ ... }: {
  normal = {
    "<Alt+x>" = "cmd-set-text :";
    "<Escape>" = "clear-keychain ;; search";

    "h" = "scroll-px -50   0";
    "j" = "scroll-px   0  50";
    "k" = "scroll-px   0 -50";
    "l" = "scroll-px  50   0";
    "gj" = "scroll-to-perc   0";
    "gk" = "scroll-to-perc 100";
    "<Ctrl+b>" = "scroll-px -50   0";
    "<Ctrl+f>" = "scroll-px  50   0";
    "<Ctrl+p>" = "scroll-px   0 -50";
    "<Ctrl+n>" = "scroll-px   0  50";

    ":" = "cmd-set-text :";
    "/" = "cmd-set-text /";
    "?" = "cmd-set-text ?";
    ";" = "hint all";
    "n" = "search-next";
    "N" = "search-prev";
    "@" = "tab-focus";
    "[" = "tab-prev";
    "]" = "tab-next";
    "{" = "tab-move -";
    "}" = "tab-move +";
  };

  insert = {
    "<Alt+x>" = "cmd-set-text :";
    "<Escape>" = "mode-leave";
    "<Insert>" = "edit-text";
    "<Ctrl+p>" = "fake-key <Up>";
    "<Ctrl+n>" = "fake-key <Down>";
    "<Ctrl+b>" = "fake-key <Left>";
    "<Ctrl+f>" = "fake-key <Right>";
  };

  hint = {
    "<Alt+x>" = "cmd-set-text :";
    "<Escape>" = "mode-leave";
    "<Return>" = "hint-follow";
    ":" = "cmd-set-text :hint ";
  };

  passthrough = {
    "<Escape>" = "mode-leave";
  };

  command = {
    "<Escape>" = "mode-leave";
    "<Insert>" = "cmd-edit";
    "<Return>" = "command-accept";
    "<Tab>" = "completion-item-focus next";
    "<Shift+Tab>" = "completion-item-focus prev";
    "<Ctrl+Tab>" = "completion-item-focus next-category";
    "<Ctrl+Shift+Tab>" = "completion-item-focus prev-category";
    "<Ctrl+n>" = "command-history-next";
    "<Ctrl+p>" = "command-history-prev";
    "<Ctrl+b>" = "rl-backward-char";
    "<Ctrl+f>" = "rl-forward-char";
    "<Ctrl+a>" = "rl-beginning-of-line";
    "<Ctrl+e>" = "rl-end-of-line";
    "<Ctrl+k>" = "rl-kill-line";
    "<Ctrl+u>" = "rl-unix-line-discard";
  };

  prompt = {
    "<Return>" = "prompt-accept";
    "<Escape>" = "mode-leave";
    "<Ctrl+c>" = "mode-leave";
    "<Tab>" = "prompt-item-focus next";
    "<Shift+Tab>" = "prompt-item-focus prev";
    "<Down>" = "prompt-item-focus next";
    "<Up>" = "prompt-item-focus prev";
    "<Ctrl+n>" = "prompt-item-focus next";
    "<Ctrl+p>" = "prompt-item-focus prev";
    "<Ctrl+a>" = "rl-beginning-of-line";
    "<Ctrl+e>" = "rl-end-of-line";
    "<Ctrl+h>" = "rl-backward-delete-char";
    "<Ctrl+k>" = "rl-kill-line";
    "<Ctrl+u>" = "rl-unix-line-discard";
    "<Ctrl+w>" = "rl-rubout \" \"";
    "<Ctrl+y>" = "rl-yank";
    "<Alt+y>" = "prompt-yank";
  };

  yesno = {
    "<Escape>" = "mode-leave";
    "y" = "prompt-accept yes";
    "n" = "prompt-accept no";
    "Y" = "prompt-accept --save yes";
    "N" = "prompt-accept --save no";
  };

  caret = {
    "<Escape>" = "mode-leave";
    "h" = "move-to-prev-char";
    "j" = "move-to-next-line";
    "k" = "move-to-prev-line";
    "l" = "move-to-next-char";
    "w" = "move-to-next-word";
    "b" = "move-to-prev-word";
    "e" = "move-to-end-of-word";
    "gh" = "move-to-start-of-line";
    "gl" = "move-to-end-of-line";
    "gj" = "move-to-start-of-document";
    "gk" = "move-to-end-of-document";
    "v" = "selection-toggle";
    "y" = "yank selection";
  };
}
