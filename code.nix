{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    zig
    zls
    taplo
    nil
    ruff
    basedpyright
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
    lua-language-server
    vue-language-server
    yaml-language-server
    elmPackages.elm-language-server
    elmPackages.elm
    julia
    meld
    uv

    bun
    lldb

    gdb
    valgrind
    radare2
    iaito

    # claude-code
  ];
}
