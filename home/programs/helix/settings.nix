{ ... }: {
  theme = "base16_clean";
  editor = {
    middle-click-paste = false;
    cursorline = false;
    cursorcolumn = false;
    idle-timeout = 1000;
    color-modes = true;
    cursor-shape = {
      insert = "block";
      normal = "block";
      select = "block";
    };
    trim-final-newlines = true;
    trim-trailing-whitespace = true;
    whitespace = {
      render = {
        space = "all";
        tab = "all";
        newline = "all";
      };
      characters = {
        space = "·";
        tab = "‣";
        tabpad = " ";
        newline = "◦";
      };
    };
    indent-guides = {
      render = true;
    };
  };
  keys = (
    let emacs = (
      act: {
        C-b = "${act}_char_left";
        C-n = "${act}_line_down";
        C-p = "${act}_line_up";
        C-f = "${act}_char_right";
        A-x = "command_mode";
      }
    );
    in {
      normal = emacs "move";
      insert = emacs "move";
      select = emacs "extend";
    }
  );
}
