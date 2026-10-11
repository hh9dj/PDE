{
  programs.direnv = {
    nix-direnv.enable = true;
    enableZshIntegration = true;
    enable = true;
    silent = true;
    stdlib = ''
      venv_activate() {
        if [[ -f .venv/bin/activate ]]; then
          watch_file .venv/bin/activate
          source .venv/bin/activate
        fi
      }
    '';
    config = {
      whitelist = {
        prefix = [
          "~/PDE/"
          "~/projects/"
        ];
      };
    };
  };
}
