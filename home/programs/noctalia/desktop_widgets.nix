{ ... }: {
  enabled = true;
  widget_order = [ "fancy_audio_visualizer" ];
  widget = {
    fancy_audio_visualizer = {
      box_height = 800;
      box_width = 800;
      cx = 853.5;
      cy = 480.0;
      output = "eDP-1";
      placement_height = 960.0;
      placement_width = 1707.0;
      rotation = 0.0;
      type = "fancy_audio_visualizer";
      settings = {
        background = false;
        bar_width = 1.0;
        bloom_intensity = 1.0;
        inner_diameter = 1.0;
        primary_color = "primary";
        ring_opacity = 1.0;
        rotation_speed = 1.0;
        secondary_color = "secondary";
        sensitivity = 1.0;
        visualization_mode = "all";
        wave_thickness = 1.0;
      };
    };
  };
}
