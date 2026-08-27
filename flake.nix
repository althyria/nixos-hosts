{
  description = "Proxmox NixOS VMS + LXC";

  inputs = {
    # Follow the unstable branch of nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Collection of pure Nix functions
    flake-utils.url = "github:numtide/flake-utils";

    # Automatic rekeying of secrets
    agenix.url = "github:ryantm/agenix";
    agenix-rekey.url = "github:oddlama/agenix-rekey";
    agenix-rekey.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, agenix, agenix-rekey, flake-utils, ... } @ inputs: {
    # Expose the necessary information in your flake so agenix-rekey
    # knows where it has too look for secrets and paths.
    agenix-rekey = agenix-rekey.configure {
      userFlake = self;
      nixosConfigurations = self.nixosConfigurations;
    };

    # Configure our systems for each host
    nixosConfigurations = {
      naglfar = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/naglfar/configuration.nix
          agenix.nixosModules.default
          agenix-rekey.nixosModules.default
        ];
        specialArgs = { inherit inputs; hostname = "naglfar"; };
      };

      heimdall = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/heimdall/configuration.nix
          agenix.nixosModules.default
          agenix-rekey.nixosModules.default
        ];
        specialArgs = { inherit inputs; hostname = "heimdall"; };
      };

      hermod = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/hermod/configuration.nix
          agenix.nixosModules.default
          agenix-rekey.nixosModules.default
        ];
        specialArgs = { inherit inputs; hostname = "hermod"; };
      };

      skuld = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/skuld/configuration.nix
          agenix.nixosModules.default
          agenix-rekey.nixosModules.default
        ];
        specialArgs = { inherit inputs; hostname = "skuld"; };
      };
    };
  }
    # Setup our devShells for nix develop
  // flake-utils.lib.eachDefaultSystem (system: rec {
    pkgs = import nixpkgs {
      inherit system;
      overlays = [ agenix-rekey.overlays.default ];
    };
    devShells.default = pkgs.mkShell {
      packages = [ pkgs.agenix-rekey ];
    };
  });
}
