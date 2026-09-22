{ assets, ...}: {
  accessibility = {
    high_contrast = false;
    ui_scale = 1.0;
  };
  audio = {
    enable_overdrive = true;
    enable_sounds = true;
    sound_volume = 0.25;
  };
  backdrop = {
    enabled = false;
  };
  bar = {
    order = [ "Top" ];
    Top = {
      background_opacity = 0.5;
      center = [ "media" "clock" "audio_visualizer" ];
      end = [ "tray" "notifications" "clipboard" "network" "bluetooth" "volume" "brightness" "battery" ];
      panel_overlap = 0;
      start = [ "launcher" "workspaces" "taskbar" ];
      widget_spacing = 12;
    };
  };
  battery = {
    warning_threshold = 20;
  };
  brightness = {
    enable_ddcutil = true;
    minimum_brightness = 0.0;
    sync_all_monitors = false;
  };
  calendar = {
    enabled = false;
  };
  control_center = {
    width = 1080;
    shortcuts = builtins.map (t: { type = t; }) [
      "wifi" "bluetooth" "caffeine" "notification"
    ];
    calendar = {
      show_week_numbers = true;
    };
  };
  desktop_widgets = import ./desktop_widgets.nix {};
  dock = {
    enabled = false;
  };
  hooks = {

  };
  hot_corners = {
    enabled = false;
  };
  idle = {
    behavior_order = [ "lock" "screen_off" ];
    behavior = {
      lock = {
        action = "lock";
        enabled = true;
        timeout = 600.0;
      };
      screen_off = {
        action = "screen_off";
        enabled = true;
        timeout = 900.0;
      };
    };
  };
  keybinds = {

  };
  location = {
    auto_locate = true;
  };
  lockscreen = {
    enabled = true;
    tint_intensity = 0.0;
  };
  lockscreen_widgets = import ./lockscreen_widgets.nix {};
  nightlight = {
    enabled = false;
  };
  notification = {
    background_opacity = 0.875;
    border = true;
    collapse_on_dismiss = true;
    enable_daemon = true;
    history_retention_hours = 24;
    layer = "overlay";
    max_visible = 0;
    position = "top_right";
    scale = 1.0;
    show_actions = true;
    show_app_name = true;
  };
  osd = {
    background_opacity = 0.875;
    border = true;
    enabled = true;
    orientation = "horizontal";
    position = "bottom_center";
    position_vertical = "bottom_center";
    scale = 1.0;
  };
  plugin_settings = {

  };
  plugins = {
    enabled = [];
  };
  shell = {
    app_icon_colorize = false;
    button_borders = true;
    card_borders = true;
    clipboard_auto_paste = "off";
    clipboard_confirm_clear_history = true;
    clipboard_enabled = true;
    clipboard_history_max_entries = 128;
    clipboard_keep_from_closed_apps = true;
    date_format = "%F %a";
    external_ip_enabled = true;
    input_borders = true;
    launch_apps_as_systemd_services = false;
    launcher = {
      provider_prefix = " ";
      providers = (
        let t = (g: p: { global = g; prefix = p; });
        in {
          calculator = t true " ";
          emoji = t false "!";
          session = t false "#";
          wallpaper = t false "$";
          windows = t true "@";
        }
      );
    };
    niri_overview_type_to_launch_enabled = false;
    password_style = "random";
    polkit_agent = true;
    popup_borders = true;
    popup_shadows = true;
    screen_time_enabled = true;
    setup_wizard_enabled = false;
    shared_gl_context = true;
    show_location = true;
    telemetry_enabled = false;
    time_format = "%T";
    panel = {
      launcher_placement = "attached";
      open_near_click_control_center = true;
      open_near_click_launcher = true;
      session_placement = "floating";
      session_position = "center";
    };
    screenshot = {
      filename_pattern = "%J-%Q";
    };
    session.actions = (
      let t = (
        a: c: s: v: {
          action = a;
          countdown_seconds = c;
          enabled = true;
          shortcut = s;
          variant = v;
        }
      );
      in [
        (t "lock"     0.0 "l" "default")
        (t "logout"   3.0 "c" "default")
        (t "reboot"   3.0 "r" "default")
        (t "shutdown" 3.0 "p" "destructive")
      ]
    );
  };
  storage = {

  };
  system.monitor = {
    enabled = true;
  };
  theme = {
    builtin = "Catppuccin";
    mode = "auto";
    templates = {
      enable_builtin_templates = false;
      enable_community_templates = false;
    };
  };
  wallpaper = {
    enabled = false;
  };
  weather = {
    effects = true;
    enabled = true;
    refresh_minutes = 60;
    unit = "metric";
  };
  widget = {
    battery = {
      hide_when_plugged = true;
    };
    bluetooth = {
      hide_when_adapater_off = true;
    };
    clock = {
      anchor = true;
      font_family = "Symbols Nerd Font Mono";
      format = "(%F %a | %T %z)";
      interactive = false;
    };
    launcher = {
      capsule = true;
      custom_image = assets."NixOS.png";
      scale = 1.5;
    };
    media = {
      hide_when_no_media = true;
    };
    network = {
      show_label = false;
    };
    workspaces = {
      show_labels = false;
    };
  };
}
