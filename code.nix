{ inputs, config, pkgs, system, ... }: {
  home.packages = with pkgs; [ zig zls taplo nil ];
}
