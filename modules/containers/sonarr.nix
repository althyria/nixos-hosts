{...}: {
  virtualisation.oci-containers.containers = {
    sonarr = {
      autoStart = true;
      image = "ghcr.io/hotio/sonarr:release-4.0.16.2944";
      ports = [
        "8989:8989/tcp"
      ];
      volumes = [
        # Media library
        "/srv/multimedia:/data:rw"
        # Container data
        "/srv/containers/sonarr:/config:rw"
      ];
      environment = {
        PUID = "1000";
        PGID = "100";
      };
      extraOptions = [
        "--network=media-stack"
      ];
    };
  };
}
