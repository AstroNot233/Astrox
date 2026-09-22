{ ... }: {
  enabled = true;
  widget_order = [
    "login_box" "calendar" "weather" "clock" "analog"
  ];
  widget = {
    "login_box" = {
      box_height = 70.0;
      box_width = 400.0;
      cx = 853.5;
      cy = 778.0;
      output = "eDP-1";
      placement_height = 960.0;
      placement_width = 1707.0;
      rotation = 0.0;
      type = "login_box";
      settings = {
        background_color = "surface_variant";
        background_opacity = 0.88;
        background_radius = 12.0;
        center_password_text = true;
        input_opacity = 1.0;
        input_radius = 6.0;
        layout = "compact";
        show_caps_lock = true;
        show_keyboard_layout = true;
        show_login_buttons = false;
        show_unlock_hint = false;
      };
    };
    "calendar" = {
      box_height = 448.0;
      box_width = 816.0;
      cx = 853.5;
      cy = 384.0;
      output = "eDP-1";
      placement_height = 960.0;
      placement_width = 1707.0;
      rotation = 0.0;
      type = "calendar";
    };
    "weather" = {
      box_height = 96.0;
      box_width = 208.0;
      cx = 1157.5;
      cy = 512.0;
      output = "eDP-1";
      placement_height = 960.0;
      placement_width = 1707.0;
      rotation = 0.0;
      type = "weather";
      settings = {
        background = false;
      };
    };
    "clock" = {
      box_height = 0.0;
      box_width = 0.0;
      cx = 1141.5;
      cy = 352.0;
      output = "eDP-1";
      placement_height = 960.0;
      placement_width = 1707.0;
      rotation = 0.0;
      type = "clock";
      settings = {
        background = false;
        center_text = true;
        color = "primary";
        font_family = "JetBrains Mono ExtraBold";
        format = "%H%n%M";
      };
    };
    "analog" = {
      box_height = 224.0;
      box_width = 240.0;
      cx = 1141.5;
      cy = 352.0;
      output = "eDP-1";
      placement_height = 960.0;
      placement_width = 1707.0;
      rotation = 0.0;
      type = "clock";
      settings = {
        background = false;
        clock_style = "analog";
      };
    };
  };
}
