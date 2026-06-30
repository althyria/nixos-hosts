{config, ...}: {
  services.borgmatic = {
    enable = true;

    settings = {
      # Directories to backup to BorgBase.
      source_directories = [
        # media-player
        "/srv/containers/jellyfin"
        # *arr
        "/srv/containers/prowlarr"
        "/srv/containers/lidarr"
        "/srv/containers/radarr"
        "/srv/containers/sonarr"
      ];

      # Our borgbase rrepository.
      repositories = [{
          path = "ssh://n5sl1kr8@n5sl1kr8.repo.borgbase.com/./repo";
          label = "naglfar on BorgBase";  
      }];

      # Miscellanious configuration options.
      compression = "auto,zstd";
      encryption_passphrase = "{credential file /etc/borgmatic/naglfar.txt}";
      archive_name_format = "{hostname}-{now:%Y-%m-%d-%H%M%S}";
      ssh_command = "ssh -i /root/.ssh/id_ed25519_borg";

      # Number of times to retry a failing backup before giving up.
      retries = 5;
      retry_wait = 5;

      keep_daily = 3;
      keep_weekly = 4;
      keep_monthly = 12;
    };
  };
}
