{ inputs, config, pkgs, system, ... }: {
  home.packages = with pkgs; [
    zig
    zls
    taplo
    nil
    ruff
    typescript-language-server
    nodePackages.prettier
    marksman
    docker-compose-language-service
    dockerfile-language-server-nodejs
    pnpm
    yarn
    helm-ls
    jq-lsp
    openscad-lsp
    svelte-language-server
    tree-sitter-grammars.tree-sitter-svelte
    dprint
    swift
    vue-language-server
    yaml-language-server
    julia

    bun
    lldb
  ];
}
