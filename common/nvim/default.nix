{
  config,
  pkgs,
  ...
}:

let
  nvim_lazy_conf = "${config.home.homeDirectory}/PDE/common/nvim/config";
in
{
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink nvim_lazy_conf;
  programs.neovim = {
    enable = true;
    sideloadInitLua = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      biome
      clang-tools
      deno
      eslint_d
      gcc
      gnumake
      go
      gofumpt
      golines
      gopls
      gotools
      just
      just-lsp
      marksman
      harper
      typescript
      pyright
      ruff
      lua-language-server
      neovim
      nixd
      nixfmt
      nodejs
      prettierd
      statix
      stylua
      taplo
      tinymist
      tree-sitter
      vscode-langservers-extracted
      vtsls
      vue-language-server
      yaml-language-server
      yamlfmt
    ];
  };
}
