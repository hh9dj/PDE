{
  programs.devenv = {
    enable = true;
    enableZshIntegration = true;
  };

  xdg.configFile."devenv/config.yaml".source = ./config.yaml;
}
