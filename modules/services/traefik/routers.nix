{...}: {
  # Configure our routers.
  services.traefik.dynamicConfigOptions.http.routers = {
    authelia = {
      rule = "Host(`auth.0x3b.sh`)";
      entryPoints = [
        "websecure"
      ];
      service = "authelia";
    };

    jellyfin = {
      rule = "Host(`je.0x3b.sh`)";
      entryPoints = [
        "websecure"
      ];
      service = "jellyfin";
    };

    sonarr = {
      rule = "Host(`so.0x3b.sh`)";
      entryPoints = [
        "websecure"
      ];
      service = "sonarr";
    };

    radarr = {
      rule = "Host(`ra.0x3b.sh`)";
      entryPoints = [
        "websecure"
      ];
      service = "radarr";
    };

    lidarr = {
      rule = "Host(`li.0x3b.sh`)";
      entryPoints = [
        "websecure"
      ];
      service = "lidarr";
    };
  };
}
