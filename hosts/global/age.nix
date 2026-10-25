{
  lib,
  inputs,
  hostDir,
  hostname,
  ...
}: {
  # YubiKey-based secret rekeying
  age.rekey = {
    hostPubkey = "${hostDir}/ssh_host_ed25519_key.pub";
    masterIdentities = [
      "${inputs.self}/hosts/global/agenix-rekey.pub"
    ];
    storageMode = "local";
    localStorageDir = ./. + "/secrets/rekeyed/${hostname}";
  };

  # Secret decryption configuration
  age.identityPaths = [
    "/etc/ssh/ssh_host_rsa_key"
    "/etc/ssh/ssh_host_ed25519_key"
  ];
}
