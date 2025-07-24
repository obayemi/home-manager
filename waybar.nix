{ config, pkgs, ... }: {
  programs.waybar = {
    package = pkgs.emptyDirectory;
    enable = true;
    systemd.enable = false;
    settings = {
      mainBar = {
        "layer" = "top"; # Waybar at top layer
        "position" = "top"; # Waybar at the bottom of your screen
        "height" = 24; # Waybar height
        "modules-left" = [
          "sway/workspaces"
          "sway/mode"
          "hyprland/workspaces"
          "hyprland/submap"
          "mpris"
        ];
        "modules-center" = [ "sway/window" ];
        "modules-right" = [
          "sway/language"
          "idle_inhibitor"
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          # "temperature"
          # "backlight"
          "battery"
          "tray"
          "clock"
        ];
        "sway/workspaces" = {
          "disable-scroll" = true;
          "all-outputs" = false;
          "format" = "{icon}";
        };
        "sway/mode" = { "format" = ''<span style="italic">{}</span>''; };
        "idle_inhibitor" = {
          "format" = "{icon}";
          "format-icons" = {
            "activated" = "";
            "deactivated" = "";
          };
        };
        "tray" = {
          # "icon-size" = 21,
          "spacing" = 10;
        };
        "clock" = { "format-alt" = "{:%Y-%m-%d}"; };
        "cpu" = {
          "format" = "{usage}% ";
          "on-click" = "kitty glances";
        };
        "memory" = {
          "format" = "{}% ";
          "on-click" = "kitty glances";
        };
        "temperature" = {
          # "thermal-zone": 2,
          # "hwmon-path": "/sys/class/hwmon/hwmon2/temp1_input"
          "critical-threshold" = 80;
          # "format-critical": "{temperatureC}°C {icon}",
          "format" = "{temperatureC}°C {icon}";
          "format-icons" = [ "" "" "" ];
        };
        "backlight" = {
          # "device" = "acpi_video1",
          "format" = "{percent}% {icon}";
          "format-icons" = [ "" "" ];
          "on-scroll-up" =
            "light -T 1.4 && light -G | cut -d'.' -f1 > $SWAYSOCK.wob";
          "on-scroll-down" =
            "light -T 0.7 && light -G | cut -d'.' -f1 > $SWAYSOCK.wob";
        };
        "battery" = {
          "bat" = "BAT1";
          "states" = {
            # "good" = 95,
            "warning" = 30;
            "critical" = 15;
          };
          "format" = "{capacity}% {icon}";
          # "format-good" = "", # An empty format will hide the module
          # "format-full" = "",
          "format-icons" = [ "" "" "" "" "" ];
        };
        "network" = {
          "interface" = "wlp*"; # (Optional) To force the use of this interface
          "format-wifi" = "{essid} ({signalStrength}%) ";
          "format-ethernet" = "{ifname}: {ipaddr}/{cidr} ";
          "format-disconnected" = "Disconnected ⚠";
          "on-click" = "foot iwctl";
          "on-click-right" = "iwctl station wlan0 disconnect";
        };
        "pulseaudio" = {
          #"scroll-step" = 1,
          "format" = "{volume}% {icon} {format_source}";
          "format-bluetooth" = "{volume}% {icon} {format_source}";
          "format-bluetooth-muted" = " {icon} {format_source}";
          "format-muted" = " {format_source}";
          "format-source" = "{volume}% ";
          "format-source-muted" = "";
          # "format" = "{volume}% {icon}",
          # "format-bluetooth" = "{volume}% {icon}",
          # "format-muted" = "",
          "format-icons" = {
            "headphones" = "";
            "handsfree" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = [ "" "" "" ];
          };
          "on-click" = "pavucontrol";
        };
        "mpris" = {
          "format" = "{player_icon} {dynamic}";
          "interval" = 1;
          "dynamic-len" = 60;
          "dynamic-order" = [ "title" "position" "length" ];
          "player-icons" = {
            "default" = "▶";
            "mpv" = "🎵";
          };
          "status-icons" = { "paused" = "⏸"; };
        };
        "sway/language" = {
          "format" = "{variant}";
          "on-click" = "swaymsg input type:keyboard xkb_switch_layout next";
        };

      };
    };
    style = ''
      * {
          border: none;
          border-radius: 0;
          font-family: "Ubuntu Nerd Font";
          font-size: 13px;
          min-height: 0;
      }

      window#waybar {
          background: transparent;
          color: white;
      }

      #window {
          font-weight: bold;
          font-family: "Ubuntu";
          min-width: 500px;
      }
      /*
      #workspaces {
          padding: 0 5px;
      }
      */

      #workspaces {
          border-radius: 0px;
          background-color: rgba(50, 50, 50, 0.7);
          margin-right: 5px;
          padding-right: 10px;
          border-radius: 0 15px 15px 0;
      }

      #workspaces button {
          padding: 0 5px;
          background: transparent;
          color: white;
          /*border-top: 2px solid transparent;*/
      }

      #workspaces button:hover {
          font-weight: lighter;
          background-color: rgba(50, 50, 50, 0.9);
      }

      #workspaces button.visible{
          color: #fb9;
          /*border-top: 2px solid #c9545d;*/
      }

      #workspaces button.focused {
          color: #c9545d;
          border-top: 2px solid #c9545d;
      }

      #mode {
          background: #64727D;
          border-bottom: 3px solid white;
      }

      #mpris, #window, #clock, #battery, #backlight, #cpu, #memory, #network, #pulseaudio, #language, #tray, #mode, #temperature, #idle_inhibitor {
          background-color: rgba(50, 50, 50, 0.7);
          border-radius: 25px;
          padding: 3px 6px;
          margin: 0 5px;
      }

      #temperature {
          color: #f0932b;
      }

      #temperature.critical {
          -color: #eb4d4b;
      }


      #clock {
          color: #64727D;
          font-weight: bold;
      }

      #battery {
      }

      #battery icon {
          color: red;
      }

      #battery.charging {
      }

      @keyframes blink {
          to {
              background-color: #ffffff;
              color: black;
          }
      }

      #battery.warning:not(.charging) {
          color: white;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      #cpu {
        color: #2ecc71;
      }

      #memory {
        color: #9b59b6;
      }

      #network {
        color: #2980b9;
      }

      #network.disconnected {
        color: #ffffff;
        background: #f53c3c;
      }

      #pulseaudio {
      }

      #pulseaudio.muted {
      }

      #custom-media {
        color: rgb(102, 220, 105);
      }

      #backlight {
        color: #90b1b1;
      }

      #pulseaudio {
        color: #f1c40f;
      }

      #pulseaudio.muted {
        color: #90b1b1;
      }

      #tray {
      }

      #idle_inhibitor.activated {
        color: #ff6666
      }
    '';
  };
}
