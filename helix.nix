{ inputs, config, pkgs, system, ... }: {
  programs.helix = {
    enable = true;
    settings = {
      theme = "dracula_transparent";
      keys.normal = {
        space.space = "file_picker";
        "C-k" = "goto_next_diag";
        "C-j" = "goto_prev_diag";
      };
      editor = {
        cursorline = true;
        color-modes = true;
        bufferline = "multiple";
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
        indent-guides.render = true;
        end-of-line-diagnostics = "hint";
        inline-diagnostics = { cursor-line = "warning"; };
      };
    };
    languages.language = [{
      name = "nix";
      auto-format = true;
      formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
    }];
    themes = {
      dracula_transparent = {
        "inherits" = "dracula";
        "ui.background" = { };
      };
    };
  };
}
