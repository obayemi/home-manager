{ inputs, config, pkgs, system, ... }:
{
  programs.helix = {
    enable = true;
    settings = {
      theme = "dracula_transparent";
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
