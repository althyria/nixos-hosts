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
    # Expose the necessary information in our flake so agenix-rekey
    # knows where it has too look for secrets and paths.
    agenix-rekey = agenix-rekey.configure {
      userFlake = self;
      nixosConfigurations = self.nixosConfigurations;
    };

    # Configure our systems for each host
    nixosConfigurations = {
      palette = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/kanto/towns/palette/configuration.nix
          agenix.nixosModules.default
          agenix-rekey.nixosModules.default
        ];
        specialArgs = {
          inherit inputs;
          hostDir = ./hosts/kanto/towns/palette;
          hostname = "palette";
        };
      };

      celadon = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/kanto/towns/celadon/configuration.nix
          agenix.nixosModules.default
          agenix-rekey.nixosModules.default
        ];
        specialArgs = { 
          inherit inputs;
          hostDir = ./hosts/kanto/towns/celadon;
          hostname = "celadon";
        };
      };

      vermilion = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/kanto/towns/vermilion/configuration.nix
          agenix.nixosModules.default
          agenix-rekey.nixosModules.default
        ];
        specialArgs = { 
          inherit inputs;
          hostDir = ./hosts/kanto/towns/vermilion;
          hostname = "vermilion";
        };
      };

      lavender = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/kanto/towns/lavender/configuration.nix
          agenix.nixosModules.default
          agenix-rekey.nixosModules.default
        ];
        specialArgs = {
          inherit inputs;
          hostDir = ./hosts/kanto/towns/lavender;
          hostname = "lavender";
        };
      };

      route1 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/kanto/routes/route1/configuration.nix
          agenix.nixosModules.default
          agenix-rekey.nixosModules.default
        ];
        specialArgs = { 
          inherit inputs;
          hostDir = ./hosts/kanto/routes/route1;
          hostname = "route1"; 
        };
      };

      route2 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/kanto/routes/route2/configuration.nix
          agenix.nixosModules.default
          agenix-rekey.nixosModules.default
        ];
        specialArgs = { 
          inherit inputs; 
          hostDir = ./hosts/kanto/routes/route2;
          hostname = "route2"; 
        };
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
