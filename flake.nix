{
  description = "proxmox nixos vms";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... } @ inputs: {
    nixosConfigurations = {
      naglfar = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/naglfar/configuration.nix
        ];
        specialArgs = { inherit inputs; };
      };
    };
  };
}
