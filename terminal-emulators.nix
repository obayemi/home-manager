{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    gnome-terminal
    terminator
    foot
    # wezterm
  ];

  programs.wezterm = {
    package = config.lib.nixGL.wrap pkgs.wezterm;
    enable = true;
    colorSchemes = {
      oba = {
        foreground = "#dddddd";
        background = "#000000";

        ansi = [
          "#000000" # black
          "#cc0403" # red
          "#19cb00" # green
          "#cecb00" # yellow
          "#0d73cc" # blue
          "#cb1ed1" # magenta
          "#0dcdcd" # cyan
          "#dddddd" # white
        ];

        brights = [
          "#767676" # bright black
          "#f2201f" # bright red
          "#23fd00" # bright green
          "#fffd00" # bright yellow
          "#1a8fff" # bright blue
          "#fd28ff" # bright magenta
          "#14ffff" # bright cyan
          "#ffffff" # bright white
        ];

        scrollbar_thumb = "#333333";

        selection_fg = "none";
        selection_bg = "rgba(50% 50% 50% 50%)";
      };
    };
    extraConfig = ''
      return {
        enable_wayland = true,
        color_scheme = "oba",
        font = wezterm.font({
          family = "Fira Code",
          harfbuzz_features = { "ss01", "ss03", "ss07", "cv02" },
        }),
        font_size = 8,
        scrollback_lines = 10000,
        enable_tab_bar = true,
        enable_scroll_bar = false,
        use_fancy_tab_bar = false,
        hide_tab_bar_if_only_one_tab = true,
        hide_mouse_cursor_when_typing = false,

        window_padding = {
          left = 0,
          right = 0,
          top = 0,
          bottom = 0,
        },

        window_background_opacity = 0.7,
      }
    '';
  };
}
