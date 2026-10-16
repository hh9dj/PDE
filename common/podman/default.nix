{ pkgs, ... }:
{
  home.packages = with pkgs; [
    podman
    buildah
    skopeo
    docker-compose
    podman-compose
  ];

  services.podman = {
    enable = true;

    settings = {
      storage.storage.driver = "overlay";
      containers.engine = {
        compose_providers = [
          "docker-compose"
          "podman-compose"
        ];
        compose_warning_logs = false;
      };

      registries.search = [ "docker.io" ];
    };

  };
}
