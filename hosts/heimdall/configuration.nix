{modulesPath, ...}: {
  imports = [
    # Global configuration.
    ../global/age.nix
    ../global/common.nix
    # Include services for this host.
    ../../modules/services/authelia
    ../../modules/services/traefik
    # Proxmox LXC.
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
  ];

  # Configuration for Nix.
  nix.settings = {
    sandbox = false;
  };

  # Setup ProxmoxLXC.
  proxmoxLXC = {
    manageNetwork = false;
    privileged = false;
  };

  # Let Proxmox host handle fstrim
  services.fstrim.enable = false;

  # LXC networking needs the firewall opened for sshd explicitly.
  services.openssh.openFirewall = true;

  # Open HTTP/HTTPS for Traefik.
  networking.firewall.allowedTCPPorts = [80 443];

  # Cache DNS lookups to improve performance
  services.resolved.settings.Resolve = {
    Cache = "yes";
    CacheFromLocalhost = "yes";
  };

  # Don't change this ...
  system.stateVersion = "26.05";
}
