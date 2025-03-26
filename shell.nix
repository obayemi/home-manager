{ config, pkgs, system, ... }: {
  home.packages = with pkgs; [
    git
    ssh-agents
    silver-searcher
    ripgrep
    delta

    bottom
    htop
    glances

    bitwarden
    bitwarden-cli

    tabiew

    pomodoro
    mani

    # wd.${system}.default
    # wd
    # (pkgs.callPackage (pkgs.fetchFromGitHub {
    #   owner = "obayemi";
    #   repo = "wd";
    #   rev = "master";
    #   hash = "sha256-zVICpdu34MhPX9SWSp/Yx66jlsy/UAi8ssGiXMnQGcU=";
    # }) {})
  ];

  home.sessionPath =
    [ "$HOME/.local/bin" "$HOME/.cargo/bin" "$HOME/.nix-profile/bin" ];
  home.sessionVariables = { };

  home.shellAliases = {
    j = "jj";
    g = "git";
    "..." = "cd ../..";
    ls = "eza";
    l = "ls -l";
    # ll = "ls -la";
    tree = "ls --tree";

    docc = "docker compose";
    ddj = "docc exec web python manage.py";
    dmsp = "ddj shell_plus";
    ddsh = "docc exec web";

    vim = "hx";
  };

  programs.bash.enable = true;
  programs.zsh.enable = true;
  programs.nushell.enable = true;
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
    ];
    shellInit = "";
    preferAbbrs = true;
    shellAbbrs = {
      docc = "docker compose";
      ddj = "docc exec web python manage.py";
      dmsp = "ddj shell_plus";
      ddsh = "docc exec web";

      g = "git";
      js = "jj status";
      jd = "jj diff";
      jjl = "jj log";
      jl = "jj l";
      l = "ls -l";
      ll = "ls -la";
      tree = "ls --tree";

      mt = "mender-cli terminal";
    };
    interactiveShellInit = ''
      if not set -q tide_left_prompt_items
        tide configure --auto --style=Rainbow --prompt_colors='16 colors' --show_time=No --rainbow_prompt_separators=Angled --powerline_prompt_heads=Sharp --powerline_prompt_tails=Flat --powerline_prompt_style='One line' --prompt_spacing=Compact --icons='Few icons' --transient=No
      end
      set fish_greeting ""
      set -g fish_key_bindings fish_vi_key_bindings
      source ${pkgs.direnv}/share/fish/vendor_conf.d/direnv.fish
      source ${pkgs.fishPlugins.fzf-fish}/share/fish/vendor_conf.d/fzf.fish

      set TTY (tty)
      set -x WLR_DRM_DEVICES '/dev/dri/card1:/dev/dri/card0'
      if status --is-login && [ "$TTY" = /dev/tty1 ]
            ssh-agent -c | source > /dev/null
            exec dbus-launch --sh-syntax --exit-with-session sway &>/tmp/sway.log
      end
    '';
    functions = {
      wd = ''
        set target (wdbin complete "$argv")

        if test "$status" -eq 0
          builtin cd "$target"
        end
      '';
      cd = ''
        set -l MAX_DIR_HIST 25

        if test (count $argv) -gt 1
            printf "%s\n" (_ "Too many args for cd command")
            return 1
        end

        # Skip history in subshells.
        if status --is-command-substitution
            builtin cd $argv
            return $status
        end

        # Avoid set completions.
        set -l previous $PWD

        if test "$argv" = "-"
            if test "$__fish_cd_direction" = "next"
                nextd
            else
                prevd
            end
            return $status
        end

        # allow explicit "cd ." if the mount-point became stale in the meantime
        if test "$argv" = "."
            cd "$PWD"
            return $status
        end

        if test (count $argv) -eq 0
          cd $HOME
          return $status
        end


        wd $argv  # notice how that's the one and only Thing that we actually want to change
        set -l cd_status $status

        if test $cd_status -eq 0 -a "$PWD" != "$previous"
            set -q dirprev
            or set -l dirprev
            set -q dirprev[$MAX_DIR_HIST]
            and set -e dirprev[1]

            # If dirprev, dirnext, __fish_cd_direction
            # are set as universal variables, honor their scope.

            set -U -q dirprev
            and set -U -a dirprev $previous
            or set -g -a dirprev $previous

            set -U -q dirnext
            and set -U -e dirnext
            or set -e dirnext

            set -U -q __fish_cd_direction
            and set -U __fish_cd_direction prev
            or set -g __fish_cd_direction prev
        end

        return $cd_status
      '';
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf.enable = true;
  programs.bat.enable = true;
  programs.htop.enable = true;

  programs.yazi.enable = true;
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "obayemi";
        email = "obayemi@ikjpz.com";
      };
      ui = {
        default-command = "log";
        editor = "nvim";
      };
      aliases = {
        s = [ "status" ];
        d = [ "diff" ];
        c = [ "commit" ];
        e = [ "edit" ];
        p = [ "git" "push" ];
        ps = [ "git" "push" ];
        f = [ "git" "fetch" ];
        l = [ "log" "-r" "(dev..@):: | (dev..@)-" ];
      };
      git.auto-local-bookmark = true;
      snapshot.max-new-file-size = 2094086;
    };
  };
  programs.k9s.enable = true;
  programs.eza.enable = true;
  programs.jq.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.fd = {
    enable = true;
    hidden = false;
    ignores = [ ];
  };

  programs.git = {
    enable = true;
    userName = "obayemi";
    userEmail = "obayemi@ikjpz.com";
    delta.enable = true;
    ignores = [ ".jj" ".env" ];
    aliases = {
      s = "status";

      a = "add";

      c = "commit";
      ca = "commit -a";
      cm = "commit -m";
      cam = "commit -am";

      ps = "push";
      pl = "pull";
      pr = "pull-request";

      ch = "checkout";

      r = "reset";
      cl = "clean";

      b = "branch";

      d = "diff";
      kd = "difftool --no-symlinks --dir-diff";
      dc = "diff --cached";

      l = "log";

      su = "submodule";

      graph =
        "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
      undo = "reset --hard";
      g = "graph";
      serve =
        "!git daemon --reuseaddr --verbose  --base-path=. --export-all ./.git";
      untrack = "rm --cache --";
      appraise = "!git-appraise";

      sub = "submodule";
    };
    extraConfig = {
      push = {
        default = "simple";
        autoSetupRemote = true;
      };
      pull.ff = "only";
      core = { editor = "vim"; };
      delta = {
        navigate = true;
        line-numbers = true;
      };
    };
  };
}
