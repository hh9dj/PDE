{
  pkgs,
  lib,
  ...
}:
let
  # Shared with Windows (windows/television/setup.ps1 copies the same file).
  shared = builtins.fromTOML (builtins.readFile ./config.toml);
  triggers = shared.shell_integration.channel_triggers;
in
{
  home.packages = with pkgs; [ xre ];
  xdg.configFile."television/cable".source = ./cable;

  # TODO: pi+tmux tv cable
  programs.television = {
    enable = true;
    enableZshIntegration = true;
    settings = lib.recursiveUpdate shared {
      # Linux/macOS-only channels (bash or macOS commands, not portable to Windows).
      shell_integration.channel_triggers = {
        # nvim goes to git-repos here, so remove it from files.
        files = lib.subtractLists [ "nvim" ] triggers.files;
        alias = [
          "alias"
          "unalias"
        ];
        env = [
          "export"
          "unset"
        ];
        spiders = [
          "scrapy crawl"
          "pls checker generate"
          "pls zone open"
          "pls"
        ];
        "docker-images" = [ "docker run" ];
        "git-repos" = [
          "nvim"
          "code"
          "hx"
          "git clone"
        ];
      };
    };
  };

  programs.zsh.initContent = lib.mkAfter ''
    bindkey "^f" tv-smart-autocomplete
  '';
}
