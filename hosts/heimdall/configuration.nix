{modulesPath, ...}: {
  imports = [
    # Global configuration.
    ../global/common.nix
    ../global/age.nix
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

  # Cache DNS lookups to improve performance
  services.resolved.settings.Resolve = {
    Cache = "yes";
    CacheFromLocalhost = "yes";
  };

  # Don't change this ...
  system.stateVersion = "26.05";
}
