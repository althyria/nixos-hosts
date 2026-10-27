{config, ...}: {
  services.paperless = {
    enable = true;

    # Config paperless
    port = 28981;
    address = "0.0.0.0";
    dataDir = "/var/lib/paperless";

    # Secrets
    passwordFile = config.age.secrets.paperless-admin.path;
    environmentFile = config.age.secrets.paperless-env.path;
  };
}
