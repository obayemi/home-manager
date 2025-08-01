{
  config,
  pkgs,
  system,
  nixgl,
  ...
}:
{
  home.packages =
    let
      glwrap = config.lib.nixGL.wrap;
    in
    with pkgs;
    [
      fira
      playerctl
      hyprdim
      pyprland

      # slicers
      # (glwrap orca-slicer)  # Temporarily disabled due to libsoup security issue
      # cura

      # pulsaudio
      pavucontrol
      helvum
      # hyprfocus
      # qutebrowser
      # logseq

      # disasemblers
      radare2
      iaito
      clipse

      (glwrap pkgs.mpv)
      (glwrap pkgs.qutebrowser)
      # (glwrap pkgs.firefox)
      # (glwrap pkgs.surf)

      hyprpolkitagent
      hyprsysteminfo

      smassh

      # nxengine-evo
      # {
      #   nixpkgs.config.allowUnfreePredicate =
      #     pkg:
      #     builtins.elem (lib.getName pkg) [
      #       "nxengine-assets"
      #     ];
      # }

      # lens
      #
      # # It is sometimes useful to fine-tune packages, for example, by applying
      # # overrides. You can do that directly here, just don't forget the
      # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
      # # fonts?
      # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')

    ];
}
