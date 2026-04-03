{...}: {
  virtualisation.oci-containers.containers = {
    jellyfin = {
      autoStart = true;
      image = "jellyfin/jellyfin:10.11.5";
      ports = [
        "8096:8096/tcp" # HTTP traffic
        "8920:8920/tcp" # HTTPS traffic
        "7359:7359/udp" # Client auto-discovery
      ];
      volumes = [
        # Media library
        "/srv/multimedia/library:/media:ro"
        # Container data
        "/srv/containers/jellyfin/config:/config:rw"
        "/srv/containers/jellyfin/cache:/cache:rw"
      ];
      environment = {
        PUID = "1000";
        PGID = "100";
      };
      extraOptions = [
        "--group-add=303"
        "--device=/dev/dri/renderD128:/dev/dri/renderD128"
        "--network=media-stack"
      ];
    };
  };
}
