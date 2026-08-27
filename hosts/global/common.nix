{
  pkgs,
  inputs,
  ...
}: {
  # Configuration for Nix.
  nix.settings = {
    trusted-users = ["serenity"];
    # Enable Nix Flakes
    experimental-features = ["nix-command" "flakes"];
  };

  # Define a user account.
  users.users.serenity = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keyFiles = [
      "${inputs.self}/hosts/serenity.pub"
    ];
    hashedPassword = "$6$c.ELrHn/TDpLtPGn$ULKyQ/pl6Ec4aQd83AFgi2ZPRUVx.b6RunW8ifl7MPX.J1Nernc4aL4VX5HMCt/qwsG5rl1oiUh34wxb5P2pp.";
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim
    wget
    tree
    rclone
  ];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PubkeyAuthentication = true;
      PasswordAuthentication = false;
    };
  };

  # Set pi-hole as DNS server.
  networking.nameservers = ["192.168.50.200"];

  # Set our time zone.
  time.timeZone = "Australia/Perth";
}
