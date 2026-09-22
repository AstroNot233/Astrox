{ ... }:
let
  inherit (builtins) elemAt map;
  colors = [
   "black"         # 00
   "red"           # 01
   "green"         # 02
   "yellow"        # 03
   "blue"          # 04
   "magenta"       # 05
   "cyan"          # 06
   "gray"          # 07
   "light-red"     # 08
   "light-green"   # 09
   "light-yellow"  # 10
   "light-blue"    # 11
   "light-magenta" # 12
   "light-cyan"    # 13
   "light-gray"    # 14
   "white"         # 15
   "#0A0C1B"       # 16
   "#E2EAFF"       # 17
  ];
  modifiers = [
    "bold"         # 0
    "dim"          # 1
    "italic"       # 2
    "underlined"   # 3
    "slow_blink"   # 4
    "rapid_blink"  # 5
    "reversed"     # 6
    "hidden"       # 7
    "crossed_out"  # 8
  ];
  underlines = [
    "line"         # 0
    "curl"         # 1
    "dashed"       # 2
    "dotted"       # 3
    "double_line"  # 4
  ];
  c = index: elemAt colors index;
  m = indexes: map (index: elemAt modifiers index) indexes;
  u = index: elemAt underlines index;
in {
  base16_clean = {
    inherits = "base16_transparent";
    "ui.selection.primary" = {
      underline = {
        color = c 04;
        style = u 1;
      };
    };
    "ui.selection.secondary" = {
      underline = {
        color = c 11;
        style = u 0;
      };
    };
  };
}
