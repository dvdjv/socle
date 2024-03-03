{
  description = "A collection of packages to support RK3588(S)-based SBCs";

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:dvdjv/nixpkgs/runtime-devtree-overlays";
    nixpkgs-23_11.url = "github:NixOS/nixpkgs/nixos-23.11";
  };

  outputs = inputs @ { self, nixpkgs, nixpkgs-23_11, ...}: let
    mkPkgs = system: repo: (
      import repo {
        localSystem = system;
        crossSystem = "aarch64-linux";

        overlays = import ./overlays;
      }
    );

    forAllSystems = function:
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ] (system: function (mkPkgs system nixpkgs) (mkPkgs system nixpkgs-23_11));
  in {
    packages = forAllSystems (pkgs: pkgs-23_11: import ./packages { inherit self pkgs pkgs-23_11; } );

    nixosModules = (import ./modules) self;
  };
}
