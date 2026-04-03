{...}: {
  virtualisation.oci-containers.containers = {
    prowlarr = {
      autoStart = true;
      image = "ghcr.io/hotio/prowlarr:release-2.3.0.5236";
      ports = [
        "9696:9696/tcp"
      ];
      volumes = [
        "/srv/containers/prowlarr:/config:rw"
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
