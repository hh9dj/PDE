{
  programs.devenv = {
    enable = true;
    enableZshIntegration = true;
  };

  home.sessionVariables = {
    DEVENV_TUI = "false";
  };

  xdg.configFile."devenv/config.yaml".source = ./config.yaml;
}
