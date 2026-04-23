{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Global configuration.
    ../global/age.nix
    # Include services for this host.
    ../../modules/services/mpd.nix
    ../../modules/services/borgmatic.nix
    # Include containers for this host.
    ../../modules/containers/jellyfin.nix
    ../../modules/containers/lidarr.nix
    ../../modules/containers/prowlarr.nix
    ../../modules/containers/qbittorrent.nix
    ../../modules/containers/radarr.nix
    ../../modules/containers/sonarr.nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Configuration for Nix.
  nix.settings = {
    trusted-users = ["serenity"];
    # Enable Nix Flakes
    experimental-features = ["nix-command" "flakes"];
  };

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

  # Set our time zone.
  time.timeZone = "Australia/Perth";

  # Define a user account.
  users.users.serenity = {
    isNormalUser = true;
    extraGroups = ["wheel" "docker"];
    packages = with pkgs; [
      tree
    ];
    openssh.authorizedKeys.keyFiles = [
      "${inputs.self}/hosts/serenity.pub"
    ];
    hashedPassword = "$6$c.ELrHn/TDpLtPGn$ULKyQ/pl6Ec4aQd83AFgi2ZPRUVx.b6RunW8ifl7MPX.J1Nernc4aL4VX5HMCt/qwsG5rl1oiUh34wxb5P2pp.";
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  # List services that we want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PubkeyAuthentication = true;
    };
  };

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

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  system.stateVersion = "25.11";
}
