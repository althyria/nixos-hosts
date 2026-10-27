{...}: {
  # Configure our services.
  services.traefik.dynamicConfigOptions.http.services = {
    authelia = {
      loadBalancer.servers = [
        {url = "http://vermilion.home.arpa:9091";}
      ];
    };

    jellyfin = {
      middlewares = ["lan-only"];
      loadBalancer.servers = [
        {url = "http://celadon.home.arpa:8096";}
      ];
    };

    sonarr = {
      middlewares = ["authelia" "lan-only"];
      loadBalancer.servers = [
        {url = "http://celadon.home.arpa:8989";}
      ];
    };

    radarr = {
      middlewares = ["authelia" "lan-only"];
      loadBalancer.servers = [
        {url = "http://celadon.home.arpa:7878";}
      ];
    };

    lidarr = {
      middlewares = ["authelia" "lan-only"];
      loadBalancer.servers = [
        {url = "http://celadon.home.arpa:8686";}
      ];
    };

    paperless = {
      middlewares = ["lan-only"];
      loadBalancer.servers = [
        {url = "http://lavender.home.arpa:28981";}
      ];
      
    };
  };
}
