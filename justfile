default:
    @just --list

build *ARGS:
  nix run nixpkgs#nixos-rebuild -- build --flake .#{{ARGS}}

deploy *ARGS:
  nix run nixpkgs#nixos-rebuild -- switch --flake .#{{ARGS}} --target-host {{ARGS}} -S

boot *ARGS:
  nix run nixpkgs#nixos-rebuild -- boot --flake .#{{ARGS}} --target-host {{ARGS}} -S

update:
  nix flake update

update-input INPUT:
  nix flake update {{INPUT}}
