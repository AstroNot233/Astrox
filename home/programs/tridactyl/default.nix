{
  lib,
  ...
}:
let
  bindArgs = mode: key: cmd: "bind --mode=${mode} ${key} ${cmd}";
  bindGroup = mode: lib.concatMapAttrsStringSep "\n" (bindArgs mode);
  bindModes = lib.concatMapAttrsStringSep "\n" (mode: scheme: bindGroup mode scheme);

  browser = {
    "<A-x>" = "fillcmdline_notrail";
  };

  emacs = {
    "<A-x>" = "fillcmdline_notrail";
    "<C-b>" = "scrollpx -50   0";
    "<C-p>" = "scrollpx   0 -50";
    "<C-n>" = "scrollpx   0  50";
    "<C-f>" = "scrollpx  50   0";
  };
in
{
  xdg.configFile."tridactyl/tridactylrc".text = lib.concatStringsSep "\n" [
    "sanitise commandline tridactylconfig tridactyllocal tridactylsync"
    "unbind --mode=* --all"

    (bindModes {
      normal = emacs;
      visual = emacs;
      insert = emacs;
      input  = emacs;
      ignore = emacs;
      browser = browser;
    })

    (bindModes {
      ex.    "<Escape>" = "ex.hide_and_clear";
      ignore."<C-Escape>" = "mode normal";
      normal."<Escape>" = "keyfeed --page <Escape>";
      visual."<Escape>" = "mode normal";
      insert."<Escape>" = "mode normal";
      input. "<Escape>" = "mode normal";
      hint.  "<Escape>" = "hint.reset";
      normal."<C-Escape>" = "mode ignore";
      visual."<C-Escape>" = "mode ignore";
      insert."<C-Escape>" = "mode ignore";
      input. "<C-Escape>" = "mode ignore";
      hint.  "<C-Escape>" = "mode ignore";
    })

    (bindGroup "normal" {
      "h" = "scrollpx -50   0";
      "j" = "scrollpx   0  50";
      "k" = "scrollpx   0 -50";
      "l" = "scrollpx  50   0";
      "gh" = "scrollto   0 x";
      "gj" = "scrollto 100 y";
      "gk" = "scrollto   0 y";
      "gl" = "scrollto 100 x";
    })

    (bindGroup "normal" {
      ";;" = "hint";
      ";:" = "fillcmdline hint";
    })

    (bindGroup "normal" {
      "/" = "fillcmdline find";
      "?" = "fillcmdline find --reverse";
      "n" = "findnext --search-from-view";
      "N" = "findnext --search-from-view --reverse";
    })

    (bindGroup "normal" {
      "i" = "hintinput";
      ":" = "fillcmdline_notrail";
      "<F1>" = "help";
    })

    (bindGroup "ex" {
      "<C-c>" = "ex.hide_and_clear";
      "<C-f>" = "ex.complete";
      "<C-j>" = "ex.accept_line";
      "<C-p>" = "ex.prev_history_or_completion";
      "<C-n>" = "ex.next_history_or_completion";
      "<C-k>" = "text.kill_line";
      "<C-u>" = "text.backward_kill_line";
      "<Enter>" = "ex.accept_line";
      "<Space>" = "ex.insert_character_or_completion";
      "<Tab>" = "ex.complete";
    })
  ];
}
