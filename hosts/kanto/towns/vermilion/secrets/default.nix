{...}: {
  age.secrets = {
    # Reverse Proxy
    traefik = {
      rekeyFile = ./traefik.age;
    };

    # Authelia
    auth-storage = {
      rekeyFile = ./auth-storage.age;
      owner = "authelia";
      group = "authelia";
      mode = "0400";
    };

    jwt_secret = {
      rekeyFile = ./jwt_secret.age;
      owner = "authelia";
      group = "authelia";
      mode = "0400";
    };

    users_database = {
      rekeyFile = ./users_database.age;
      path = "/etc/authelia/users_database.yml";
      owner = "authelia";
      group = "authelia";
      mode = "0400";
    };
  };
}
