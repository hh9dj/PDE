{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "Host github.com-niq".HostName = "github.com";
      "Host github.com-niq".IdentityFile = "~/.ssh/work";

      "Host homelab".HostName = "192.168.1.176";
      "Host homelab".User = "khalil";

      "*" = {
        AddKeysToAgent = "yes";
        IdentityFile = "~/.ssh/personal";
        StrictHostKeyChecking = "accept-new";
      };
    };
  };

  home.file.".ssh/personal.pub".source = ./personal.pub;
}
