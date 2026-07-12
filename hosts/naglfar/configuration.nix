{
  pkgs,
  ...
}: {
  imports = [
    # Global configuration.
    ../global/common.nix
    ../global/age.nix
    # Include services for this host.
    ../../modules/services/mpd.nix
    ../../modules/services/borgmatic.nix
    # Include containers for this host.
    ../../modules/containers/jellyfin.nix
    ../../modules/containers/lidarr.nix
    ../../modules/containers/prowlarr.nix
    ../../modules/containers/radarr.nix
    ../../modules/containers/sonarr.nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Configure our networking.
  networking = {
    hostName = "naglfar";
    useDHCP = true;
  };

  # Add this host's docker group to the user account.
  users.users.serenity.extraGroups = ["docker"];

  # Manage linux containers
  virtualisation = {
    docker = {
      enable = true;
      liveRestore = false;
    };
    # Implementation to use for containers
    oci-containers.backend = "docker";
  };

  # Create network for our media-stack.
  systemd.services.init-media-stack-network = {
    description = "Create media-stack docker network";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig.Type = "oneshot";
    script = ''
      ${pkgs.docker}/bin/docker network create media-stack || true
    '';
  };

  # Don't change this ...
  system.stateVersion = "25.11";
}
