{ ... }: ''
  # Custom bindings, written in mpv's native input.conf syntax so the action for
  # every key stays on one line. Loaded after the built-in defaults, hence an
  # entry here overrides a default but never unbinds the rest of them.

  # Emacs movement keys. mpv's own defaults are preserved: C-n/C-p duplicate the
  # 5-second arrow seek, so holding either key stays a useful coarse seek.
  Ctrl+n  seek 5          # emacs line down
  Ctrl+p  seek -5         # emacs line up
  Ctrl+f  frame-step      # emacs char right
  Ctrl+b  frame-back-step # emacs char left
  Alt+f   seek 1          # emacs word right
  Alt+b   seek -1         # emacs word left
  Ctrl+v  seek 600        # emacs scroll up, same step as the Shift+PgUp default
  Alt+v   seek -600       # emacs scroll down, same step as the Shift+PgDn default
  Alt+n   add sub-pos 1   # emacs next line, subtitle timing
  Alt+p   add sub-pos -1  # emacs previous line, subtitle timing
  Alt+>   playlist-next   # emacs end-of-buffer, next file
  Alt+<   playlist-prev   # emacs beginning-of-buffer, previous file
  Alt+x   script-binding console/enable # emacs M-x, mpv's own ` is kept

  # Mouse. The defaults are written out so the intended click and wheel
  # behaviour is visible in place; MBTN_LEFT stays unbound for the OSC.
  MBTN_LEFT      ignore
  MBTN_LEFT_DBL  cycle fullscreen
  MBTN_RIGHT     cycle pause
  MBTN_BACK      playlist-prev
  MBTN_FORWARD   playlist-next
  WHEEL_UP       add volume 2
  WHEEL_DOWN     add volume -2
  WHEEL_LEFT     seek -10
  WHEEL_RIGHT    seek 10
''
