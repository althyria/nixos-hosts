{
  lib,
  hostname,
  ...
}: {
  # Secret decryption configuration
  age.identityPaths = [
    "/etc/ssh/ssh_host_rsa_key"
    "/etc/ssh/ssh_host_ed25519_key"
  ];

  # YubiKey-based secret rekeying
  age.rekey = {
    hostPubkey = ../${hostname}/ssh_host_ed25519_key.pub;
    masterIdentities = [
      ./secrets/agenix-rekey.pub
    ];
    storageMode = "local";
    localStorageDir = ./. + "/secrets/rekeyed/${hostname}";
  };

  # Secrets for each host.
  age.secrets = lib.mkMerge [
    # Naglfar
    (lib.mkIf (hostname == "naglfar") {
      borgmatic = {
        rekeyFile = ./secrets/naglfar-borg.age;
        path = "/etc/borgmatic/naglfar.txt";
      };

      rclone-mount-conf = {
        rekeyFile = ./secrets/rclone-mount.age;
        path = "/etc/rclone-mount.conf";
      };
    })

    # Heimdall
    (lib.mkIf (hostname == "heimdall") {
      traefik = {
        rekeyFile = ./secrets/traefik.age;
      };

      # Authelia
      auth-storage = {
        rekeyFile = ./secrets/auth-storage.age;
        owner = "authelia";
        group = "authelia";
        mode = "0400";
      };

      jwt_secret = {
        rekeyFile = ./secrets/jwt_secret.age;
        owner = "authelia";
        group = "authelia";
        mode = "0400";
      };

      users_database = {
        rekeyFile = ./secrets/users_database.age;
        path = "/etc/authelia/users_database.yml";
        owner = "authelia";
        group = "authelia";
        mode = "0400";
      };
    })
  ];
}
