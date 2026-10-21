{ ... }: ''
  # input.conf syntax: one action per line, loaded after mpv's own defaults.

  # Emacs movement keys.
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

  # Mouse: defaults written out; MBTN_LEFT stays unbound for the OSC.
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
