{...}: {
  services.traefik.dynamicConfigOptions.http.middlewares = {
    # LAN only whitelist for internal services
    lan-only.ipAllowList = {
      sourceRange = [
        "127.0.0.1/32"
        "192.168.50.0/24"
      ];
      rejectStatusCode = 404;
    };

    # Authentication
    authelia.forwardAuth = {
      address = "http://localhost:9091/api/verify?rd=https%3A%2F%2Fauth.0x3b.sh%2F";
      trustForwardHeader = true;
      authResponseHeaders = [
        "Remote-User"
        "Remote-Groups"
        "Remote-Email"
        "Remote-Name"
      ];
    };
  };
}
