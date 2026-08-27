{...}: {
  # Configure our services.
  services.traefik.dynamicConfigOptions.http.services = {
    authelia = {
      loadBalancer.servers = [
        {url = "http://heimdall.home.arpa:9091";}
      ];
    };

    jellyfin = {
      middlewares = ["lan-only"];
      loadBalancer.servers = [
        {url = "http://naglfar.home.arpa:8096";}
      ];
    };

    sonarr = {
      middlewares = ["authelia" "lan-only"];
      loadBalancer.servers = [
        {url = "http://naglfar.home.arpa:8989";}
      ];
    };

    radarr = {
      middlewares = ["authelia" "lan-only"];
      loadBalancer.servers = [
        {url = "http://naglfar.home.arpa:7878";}
      ];
    };

    lidarr = {
      middlewares = ["authelia" "lan-only"];
      loadBalancer.servers = [
        {url = "http://naglfar.home.arpa:8686";}
      ];
    };
  };
}
