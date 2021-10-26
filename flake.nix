{
  description = "A very basic flake";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (import ./default.nix { inherit pkgs; })
          sources package shell nodeDependencies;
        node2nix = package;
        app = flake-utils.lib.mkApp {
          drv = package;
          exePath = "/bin/node2nix";
        };
        overlays = final: prev: { node2nix = node2nix; };
      in {
        packages.node2nix = node2nix;
        defaultPackage = node2nix;
        apps.node2nix = app;
        defaultApp = app;
        nodeDependencies = nodeDependencies;
        nodeShell = shell;
        inherit overlays;
      });
}
