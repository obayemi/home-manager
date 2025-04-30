{ config, pkgs, ... }: {
  home.packages = with pkgs; [ sway dmenu wob wdisplays ];
  programs.swayr = { enable = true; };
  services.kanshi = {
    enable = true;
    settings = [
      {
        profile.name = "standalone";
        profile.outputs = [{
          criteria = "eDP-1";
          status = "enable";
          scale = 1.2;
          mode = "2256x1504";
        }];
      }
      {
        profile.name = "work";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            scale = 1.4;
            mode = "2256x1504";
            position = "0,0";
          }
          {
            criteria = "Dell Inc. DELL U2518D 3C4YP95TBJ5L";
            status = "enable";
            mode = "2560x1440";
            position = "1613,0";
          }
          {
            criteria = "Dell Inc. DELL U2518D 3C4YP95TBQ5L";
            status = "enable";
            mode = "2560x1440";
            position = "4173,0";
          }
        ];
      }
      {
        profile.name = "centaurus";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            scale = 1.2;
            mode = "2256x1504";
          }
          {
            criteria = "XMD Mi TV 0x00000001";
            status = "enable";
            scale = 2.0;
            mode = "3840x2160";
          }
        ];
      }
      #   profile lan {
      #     output 'AOC AG241QG4 0x00000151' enable position 0,0 mode 2560x1440
      #     output eDP-1 scale 1.2 position 2560,0 mode 2256x1504
      #   }
    ];

  };
  services.swayidle.enable = true;
  wayland.windowManager.sway = {
    enable = true;
    config = {

      modifier = "Mod4";
      terminal = "wezterm";
      menu = "fuzzel --show-actions";

      bars = [{ command = "waybar"; }];

      keybindings = { };

      focus = { followMouse = false; };
      gaps = {
        inner = 3;
        smartBorders = "on";
      };

      colors = {
        # background = ;
        focused = {
          border = "#859900";
          background = "#c8e600";
          text = "#073642";
          indicator = "#859900";
          childBorder = "#859900";
        };
        focusedInactive = {
          border = "#073642";
          background = "#8ca100";
          text = "#eee8d5";
          indicator = "#2aa198";
          childBorder = "#073642";
        };
        unfocused = {
          border = "#073642";
          background = "#0a4959";
          text = "#eee8d5";
          indicator = "#2aa198";
          childBorder = "#073642";
        };
        urgent = {
          border = "#ff1111";
          background = "#ff1111";
          text = "#eee8d5";
          indicator = "#ff1111";
          childBorder = "#ff1111";
        };
        placeholder = {
          border = "#000000";
          background = "#000000";
          text = "#000000";
          indicator = "#000000";
          childBorder = "#000000";
        };
      };
      modes = {
        resize = {
          Down = "resize grow height 10 px";
          Escape = "mode default";
          Left = "resize shrink width 10 px";
          Return = "mode default";
          Right = "resize grow width 10 px";
          Up = "resize shrink height 10 px";
          h = "resize shrink width 10 px";
          j = "resize grow height 10 px";
          k = "resize shrink height 10 px";
          l = "resize grow width 10 px";
        };
      };
    };
    # xwayland = false;
    systemd.enable = false;
    extraConfig = ''
      exec dbus-update-activation-environment DISPLAY I3SOCK SWAYSOCK WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=$nameofcompositor
      #
      # ### Variables
      # #
      # set $color0 #073642
      # set $color8 #002b36
      # set $color1 #dc322f
      # set $color9 #cb4b16
      # set $color2 #859900
      # set $color10 #586e75
      # set $color3 #b58900
      # set $color11 #657b83
      # set $color4 #268bd2
      # set $color12 #839496
      # set $color5 #d33682
      # set $color13 #6c71c4
      # set $color6 #2aa198
      # set $color14 #93a1a1
      # set $color7 #eee8d5
      # set $color15 #fdf6e3
      #
      # set $border_color $color0
      # set $focused_border_color $color4
      #
      set $mod Mod4
      set $Alt Mod1
      # Home row direction keys, like vim
      set $left h
      set $down j
      set $up k
      set $right l
      # Your preferred terminal emulator
      # set $term foot
      set $term /usr/bin/wezterm start --always-new-process
      # Your preferred application launcher
      # Note: pass the final command to swaymsg so that the resulting window can be opened
      # on the original workspace that the command was run on.
      set $menu fuzzel --show-actions
      #
      exec kanshi
      exec_always kanshictl reload
      exec playerctld


      ### Background stuff

      exec pipewire
      exec /usr/libexec/xdg-desktop-portal --verbose -r
      # exec autotiling
      exec sworkstyle > /tmp/sworkstyle.log
      exec mako --default-timeout 5000
      exec mkfifo $SWAYSOCK.wob && tail -f $SWAYSOCK.wob | wob
      exec_always sh -c '$HOME/.local/bin/wallp'
      exec wl-paste --watch cliphist store

      exec earlyoom -n --syslog -r 60
      exec swayrd


      ### Idle configuration
      #
      # Example configuration:
      #
      exec swayidle -w \
              timeout 300 '$HOME/.local/bin/randlock' \
              timeout 600 'swaymsg "output * power off"' resume 'swaymsg "output * power on"' \
              before-sleep '$HOME/.local/bin/randlock'
      #
      # This will lock your screen after 300 seconds of inactivity, then turn off
      # your displays after another 300 seconds, and turn your screens back on when
      # resumed. It will also lock your screen before your computer goes to sleep.

      ### Input configuration
      #
      # Example configuration:
      #
      #   input "2:14:SynPS/2_Synaptics_TouchPad" {
      #       dwt enabled
      #       tap enabled
      #       natural_scroll enabled
      #       middle_emulation enabled
      #   }
      #
      # You can get the names of your inputs by running: swaymsg -t get_inputs
      # Read `man 5 sway-input` for more information about this section.

      input "type:touchpad" {
        tap enabled
        tap_button_map lmr
        dwt enabled
        # natural_scroll enabled
        middle_emulation enabled
      }

      # ,us(dvorak-alt-intl)

      input "type:keyboard" {
              xkb_layout us(altgr-intl),us(dvorak-alt-intl)
              xkb_options caps:escape,grp:shifts_toggle
      }

      # input "type:tablet_tool" {
      #   map_to_output 'LG Electronics LG ULTRAGEAR 104NTNH6V047'
      #   map_from_region 0.0x0.0 0.5x0.5
      # }

      ### Key bindings
      #
      # Basics:
      #
          # Start a terminal
          bindsym $mod+Return exec $term
          # bindsym $mod+Return exec Warp-x86_64.AppImage
          # bindsym $mod+Shift+Return exec $term pwsh
          bindsym $mod+Shift+Return exec $term sh
          # bindsym $mod+Shift+Return exec $term

          # Kill focused window
          bindsym $mod+Shift+q kill

          # Start your launcher
          bindsym $mod+e           exec $menu
          bindsym $mod+Shift+e     exec "kickoff"
          bindsym $mod+Space       exec swayr switch-window

          # Drag floating windows by holding down $mod and left mouse button.
          # Resize them with right mouse button + $mod.
          # Despite the name, also works for non-floating windows.
          # Change normal to inverse to use left mouse button for resizing and right
          # mouse button for dragging.
          floating_modifier $mod normal

          # Reload the configuration file
          bindsym $mod+Shift+c reload

          # Exit sway (logs you out of your Wayland session)
          # bindsym $mod+Shift+e exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'
      #
      # Moving around:
      #
          focus_wrapping yes

          # Move your focus around
          bindsym $mod+$left focus left
          bindsym $mod+$down focus down
          bindsym $mod+$up focus up
          bindsym $mod+$right focus right
          # Or use $mod+[up|down|left|right]
          bindsym $mod+Left focus left
          bindsym $mod+Down focus down
          bindsym $mod+Up focus up
          bindsym $mod+Right focus right

          # Move the focused window with the same, but add Shift
          bindsym $mod+Shift+$left move left
          bindsym $mod+Shift+$down move down
          bindsym $mod+Shift+$up move up
          bindsym $mod+Shift+$right move right
          # Ditto, with arrow keys
          bindsym $mod+Shift+Left move left
          bindsym $mod+Shift+Down move down
          bindsym $mod+Shift+Up move up
          bindsym $mod+Shift+Right move right
      #
      # Workspaces:
      #
          # Switch to workspace bindsym $mod+1 workspace number 1
          bindsym $mod+1 workspace number 1
          bindsym $mod+2 workspace number 2
          bindsym $mod+3 workspace number 3
          bindsym $mod+4 workspace number 4
          bindsym $mod+5 workspace number 5
          bindsym $mod+6 workspace number 6
          bindsym $mod+7 workspace number 7
          bindsym $mod+8 workspace number 8
          bindsym $mod+9 workspace number 9
          bindsym $mod+0 workspace number 10
          # Move focused container to workspace
          bindsym $mod+Shift+1 move container to workspace number 1
          bindsym $mod+Shift+2 move container to workspace number 2
          bindsym $mod+Shift+3 move container to workspace number 3
          bindsym $mod+Shift+4 move container to workspace number 4
          bindsym $mod+Shift+5 move container to workspace number 5
          bindsym $mod+Shift+6 move container to workspace number 6
          bindsym $mod+Shift+7 move container to workspace number 7
          bindsym $mod+Shift+8 move container to workspace number 8
          bindsym $mod+Shift+9 move container to workspace number 9
          bindsym $mod+Shift+0 move container to workspace number 10
          # Note: workspaces can have any name you want, not just numbers.
          # We just use 1-10 as the default.

          bindsym $Alt+Control+Left workspace prev
          bindsym $Alt+Control+Right workspace next
          bindsym $mod+$Alt+Control+Left workspace prev
          bindsym $mod+$Alt+Control+Right workspace next

          bindsym $Alt+Control+$left workspace prev
          bindsym $Alt+Control+$right workspace next
          bindsym $mod+$Alt+Control+$left workspace prev
          bindsym $mod+$Alt+Control+$right workspace next

          bindsym $Alt+Control+Shift+Left move container to workspace prev workspace prev
          bindsym $Alt+Control+Shift+Right move container to workspace next workspace next
          bindsym $Alt+Control+Shift+$left move container to workspace prev workspace prev
          bindsym $Alt+Control+Shift+$right move container to workspace next workspace next

          bindsym $mod+Control+Left move container to workspace prev
          bindsym $mod+Control+Right move container to workspace next
          bindsym $mod+Control+$left move container to workspace prev
          bindsym $mod+Control+$right move container to workspace next


          bindsym $mod+Tab workspace back_and_forth
          bindsym $Alt+Tab workspace back_and_forth
          workspace_auto_back_and_forth yes

          bindsym $mod+x move workspace to output right
          bindsym $mod+Shift+x move container to output right

          bindsym $mod+$Alt+$right focus output right
          bindsym $mod+$Alt+$left focus output left
          bindsym $mod+$Alt+Right focus output right
          bindsym $mod+$Alt+Left focus output left

          bindgesture swipe:right workspace next
          bindgesture swipe:left workspace prev

          bindgesture pinch:inward+up move up
          bindgesture pinch:inward+down move down
          bindgesture pinch:inward+left move left
          bindgesture pinch:inward+right move right

      #
      # Layout stuff:
      #
          # You can "split" the current object of your focus with
          # $mod+b or $mod+v, for horizontal and vertical splits
          # respectively.
          bindsym $mod+b splith
          bindsym $mod+v splitv

          # Switch the current container between different layout styles
          # bindsym $mod+s layout stacking  # I do not care about stacking, big waste of space
          bindsym $mod+d layout tabbed
          bindsym $mod+s layout toggle split

          # Make the current focus fullscreen
          bindsym $mod+f fullscreen

          # Toggle the current focus between tiling and floating mode
          bindsym $mod+Shift+space floating toggle

          # Swap focus between the tiling area and the floating area
          # bindsym $mod+space focus mode_toggle

          # Move focus to the parent container
          bindsym $mod+a focus parent
          bindsym $mod+z focus child

          bindsym $mod+Shift+s sticky toggle
      #
      # Scratchpad:
      #
          # Sway has a "scratchpad", which is a bag of holding for windows.
          # You can send windows there and get them back later.

          # Move the currently focused window to the scratchpad
          bindsym $mod+Shift+minus move scratchpad

          # Show the next scratchpad window or hide the focused scratchpad window.
          # If there are multiple scratchpad windows, this command cycles through them.
          bindsym $mod+minus scratchpad show
      #
      # Resizing containers:
      #
      # mode "resize" {
      #     # left will shrink the containers width
      #     # right will grow the containers width
      #     # up will shrink the containers height
      #     # down will grow the containers height
      #     bindsym $left resize shrink width 10px
      #     bindsym $down resize grow height 10px
      #     bindsym $up resize shrink height 10px
      #     bindsym $right resize grow width 10px
      #
      #     # Ditto, with arrow keys
      #     bindsym Left resize shrink width 10px
      #     bindsym Down resize grow height 10px
      #     bindsym Up resize shrink height 10px
      #     bindsym Right resize grow width 10px
      #
      #     # Return to default mode
      #     bindsym Return mode "default"
      #     bindsym Escape mode "default"
      # }

      bindsym $mod+r mode "resize"
      bindsym $mod+c mode "resize"

      mode "void" {
        bindsym $mod+Shift+Escape mode "default"
      }
      bindsym $mod+Shift+Escape mode "void"
      #
      # gaps inner 3
      # focus_follows_mouse no
      # focus_wrapping no
      # smart_borders on
      # smart_gaps on
      #
      #
      # # class                 border  backgr. text    indicator child_border
      # client.focused          $color2 #c8e600 $color0 $color2   $color2
      # client.focused_inactive $color0 #8ca100 $color7 $color6   $color0
      # client.unfocused        $color0 #0a4959 $color7 $color6   $color0
      # client.urgent           #ff1111 #ff1111 $color7 #ff1111   #ff1111
      # client.placeholder      $bg     $bg     $bg     $bg       $bg

      # default_border pixel 1

      for_window [app_id="termfloat"] floating enable
      for_window [app_id="termfloat"] resize set height 500
      for_window [app_id="termfloat"] resize set width 900

      for_window [window_role="pop-up"] floating enable
      for_window [window_role="bubble"] floating enable
      for_window [window_role="task_dialog"] floating enable
      for_window [window_role="Preferences"] floating enable
      for_window [window_type="dialog"] floating enable
      for_window [window_type="menu"] floating enable
      for_window [window_role="About"] floating enable

      bindsym Control+Shift+1 exec grimshot copy active
      bindsym Control+Shift+2 exec grimshot copy window
      bindsym Control+Shift+3 exec grimshot copy area

      bindsym $mod+F11 exec "$HOME/.local/bin/wallp"

      bindsym $mod+o exec "$HOME/.local/bin/randlock"
      #bindsym $mod+o exec "swaylock"

      bindsym XF86AudioMute exec "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      bindsym XF86AudioLowerVolume  exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      bindsym XF86AudioRaiseVolume  exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"

      bindsym XF86MonBrightnessUp exec light -T 1.4 && light -G | cut -d'.' -f1 > $SWAYSOCK.wob
      bindsym XF86MonBrightnessDown exec light -T 0.7 && light -G | cut -d'.' -f1 > $SWAYSOCK.wob


      bindsym $mod+w exec $term --class termfloat evcxr
      bindsym $mod+Shift+w exec $term --class termfloat $HOME/.local/bin/Codi

      for_window [class="^.*"] border pixel 1

      include /etc/sway/config.d/*
    '';
  };
  imports = [ ./waybar.nix ];
}
