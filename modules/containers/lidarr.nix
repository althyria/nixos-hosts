{...}: {
  virtualisation.oci-containers.containers = {
    lidarr = {
      autoStart = true;
      image = "ghcr.io/hotio/lidarr:release-3.1.0.4875";
      ports = [
        "8686:8686/tcp"
      ];
      volumes = [
        # Media library
        "/srv/multimedia:/data:rw"
        # Container data
        "/srv/containers/lidarr:/config:rw"
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
