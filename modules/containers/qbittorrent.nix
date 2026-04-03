{...}: {
  virtualisation.oci-containers.containers = {
    qbittorrent = {
      autoStart = true;
      image = "ghcr.io/hotio/qbittorrent:release-5.1.4";
      ports = [
        "8487:8080/tcp"   # WebUI
        "32372:32372/tcp" # Transport protocol
      ];
      volumes = [
        "/srv/multimedia/torrents:/data/torrents:rw"
        "/srv/containers/qbittorrent:/config:rw"
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
