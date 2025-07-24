{ pkgs, ... }: {
  programs.helix = {
    enable = true;
    settings = {
      theme = "dracula_transparent";
      keys = {
        normal = {
          "X" = "extend_line_above";
          space.space = "file_picker";
          "C-j" = "goto_next_diag";
          "C-k" = "goto_prev_diag";
          esc = [ "collapse_selection" "keep_primary_selection" ];
        };
        insert."C-space" = "completion";
      };
      editor = {
        cursorline = true;
        color-modes = true;
        bufferline = "multiple";
        auto-pairs = false;
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
        indent-guides.render = true;
        end-of-line-diagnostics = "hint";
        inline-diagnostics = { cursor-line = "warning"; };
        # whitespace.render = "all";
        # whitespace.characters = {
        #   # space = "·";
        #   nbsp = "⍽";
        #   tab = "→";
        #   newline = "⤶";
        # };
      };
    };

    languages = {
      language-server = { rust-analyzer.config.leptos_macro = [ "server" ]; };
      language = [
        # {
        #   name = "rust";
        # }
        {
          name = "tsx";
          formatter = {
            command = "prettier";
            args = [ "--parser" "typescript" ];
          };
          auto-format = true;
        }
        {
          name = "jsx";
          formatter = {
            command = "prettier";
            args = [ "--parser" "typescript" ];
          };
          auto-format = true;
        }
        {
          name = "typescript";
          formatter = {
            command = "prettier";
            args = [ "--parser" "typescript" ];
          };
          auto-format = true;
        }
        {
          name = "javascript";
          formatter = {
            command = "prettier";
            args = [ "--parser" "typescript" ];
          };
          auto-format = true;
        }
        {
          name = "html";
          formatter = {
            command = "prettier";
            args = [ "--parser" "angular" ];
          };
          auto-format = true;
        }
        {
          name = "json";
          formatter = {
            command = "prettier";
            args = [ "--parser" "json" ];
          };
          auto-format = true;
        }
        {
          name = "css";
          formatter = {
            command = "prettier";
            args = [ "--parser" "css" ];
          };
          auto-format = true;
        }
        {
          name = "nix";
          auto-format = true;
          formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
        }
        {
          name = "python";
          auto-format = true;
          formatter.command = "${pkgs.ruff} format";
        }
      ];
    };
    themes = {
      dracula_transparent = {
        "inherits" = "dracula";
        "ui.background" = { };
      };
    };
  };
}
