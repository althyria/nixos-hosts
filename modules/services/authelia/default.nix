{config, ...}: {
  # We must create our authelia user for secret management.
  users.users.authelia = {
    group = "authelia";
    isSystemUser = true;
  };
  users.groups.authelia = {};

  # Setup our authentication service.
  services.authelia.instances."main" = {
    enable = true;

    # user:group to run the service as.
    user = "authelia";
    group = "authelia";

    # Retrieve our secrets.
    secrets = {
      storageEncryptionKeyFile = config.age.secrets.auth-storage.path;
      jwtSecretFile = config.age.secrets.jwt_secret.path;
    };

    # Configure our settings.
    settings = {
      authentication_backend.file.path = "/etc/authelia/users_database.yml";

      # Setup access control domains and policies.
      access_control = {
        default_policy = "deny";
        rules = [
          {
            domain = "*.0x3b.sh";
            policy = "one_factor";
          }
        ];
      };
      session.domain = "0x3b.sh"; # Protect session with cookie

      # Miscellaneous.
      storage.local.path = "/tmp/db.sqlite3";
      notifier.filesystem.filename = "/tmp/notifications.txt";
    };
  };
}
