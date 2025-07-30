{ inputs, config, pkgs, lib, system, nixgl, ... }:
let inherit (inputs) wd;
in {
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "nxengine-assets"
  ];
  home.username = "obayemi";
  home.homeDirectory = "/home/obayemi";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # flakes are hard :(
  # TODO: find how to put that in ./shell.nix
  home.packages = [ wd.defaultPackage.${system} ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/obayemi/etc/profile.d/hm-session-vars.sh
  #
  #

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  nixGL.packages = nixgl.packages;
  # nixGL.defaultWrapper = "mesa";
  # nixGL.installScripts = [ "mesa" ];

  # wayland.windowManager.sway.enable = true;

  imports = [
    ./programs.nix
    ./shell.nix
    ./terminal-emulators.nix
    ./wm.nix
    ./sway.nix
    ./hyprland.nix
    ./waybar.nix
    ./kanshi.nix
    ./helix.nix
    ./code.nix
    ./neovim.nix
  ];

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  xdg.enable = true;
  xdg.portal.config.common.default = "*";
}
