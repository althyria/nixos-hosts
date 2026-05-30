{config, lib, ...}: let
  hostname = config.networking.hostName;
in {
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
  ];
}
