{
  lib,
  inputs,
  hostDir,
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
    hostPubkey = "${hostDir}/ssh_host_ed25519_key.pub";
    masterIdentities = [
      "${inputs.self}/hosts/global/agenix-rekey.pub"
      # "/home/serenity/.repo/nixos-hosts/hosts/global/agenix-rekey.pub"
    ];
    storageMode = "local";
    localStorageDir = ./. + "/secrets/rekeyed/${hostname}";
  };

  # Secrets for each host.
  age.secrets = lib.mkMerge [
    # Celadon
    (lib.mkIf (hostname == "celadon") {
      borgmatic = {
        rekeyFile = ./secrets/celadon-borg.age;
        path = "/etc/borgmatic/celadon.txt";
      };

      rclone-mount-conf = {
        rekeyFile = ./secrets/rclone-mount.age;
        path = "/etc/rclone-mount.conf";
      };
    })

    # Vermilion
    (lib.mkIf (hostname == "vermilion") {
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
