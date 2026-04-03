{...}: {
  virtualisation.oci-containers.containers = {
    radarr = {
      autoStart = true;
      image = "ghcr.io/hotio/radarr:release-6.0.4.10291";
      ports = [
        "7878:7878/tcp"
      ];
      volumes = [
        # Media library
        "/srv/multimedia:/data:rw"
        # Container data
        "/srv/containers/radarr:/config:rw"
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
