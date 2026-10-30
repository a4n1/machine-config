{ ... }:
{
  programs.noctalia = {
    enable = true;

    settings = {
      theme = {
        mode = "dark";
        source = "custom";
        custom_palette = "CatppuccinBlack";
      };

      bar = {
        default = {
          thickness = 32;
          padding = 12;
          margin_ends = 0;
          radius_top_left = 0;
          radius_top_right = 0;
          start = ["session" "control-center"];
          center = [];
          end = ["notifications" "battery" "clock"];
        };
      };

      widget = {
        control-center = {
          glyph = "adjustments";
        };

        battery = {
          display_mode = "graphic";
        };
      };

      wallpaper = {
        enabled = true;
        default.path = ../wallpaper.png;
      };

      shell = {
        launcher = {
          layout = "simple";
          categories = false;
          compact = true;
        };
      };

      lockscreen = {
        lock_before_suspend = false;
        grace_period_seconds = 5;
        transition = [ "disc" ];
        transition_duration = 1000;
      };

      lockscreen_widgets = {
        enabled = true;
      };
    };

    customPalettes.CatppuccinBlack = {
      version = 2;
      dark = {
        primary = "#89b4fa";
        on_primary = "#000000";
        secondary = "#89b4fa";
        on_secondary = "#000000";
        tertiary = "#94e2d5";
        on_tertiary = "#000000";
        error = "#f38ba8";
        on_error = "#000000";
        surface = "#000000";
        on_surface = "#cdd6f4";
        surface_container = "#11111b";
        on_surface_variant = "#bac2de";
        outline_variant = "#585b70";
        shadow = "#000000";
        hover = "#b4befe";
        on_hover = "#000000";

        terminal = {
          foreground = "#cdd6f4";
          background = "#000000";
          cursor = "#f5e0dc";
          cursor_text = "#000000";
          selection_fg = "#cdd6f4";
          selection_bg = "#585b70";

          normal = {
            black = "#45475a";
            red = "#f38ba8";
            green = "#a6e3a1";
            yellow = "#f9e2af";
            blue = "#89b4fa";
            magenta = "#f5c2e7";
            cyan = "#94e2d5";
            white = "#bac2de";
          };

          bright = {
            black = "#585b70";
            red = "#f38ba8";
            green = "#a6e3a1";
            yellow = "#f9e2af";
            blue = "#89b4fa";
            magenta = "#f5c2e7";
            cyan = "#94e2d5";
            white = "#a6adc8";
          };
        };
      };
    };
  };
}
