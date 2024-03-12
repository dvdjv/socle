{
  description = "A collection of packages to support RK3588(S)-based SBCs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ { self, nixpkgs, ...}: let
    mkPkgs = system: (
      import nixpkgs {
        localSystem = system;
        crossSystem = "aarch64-linux";

        overlays = import ./overlays;
      }
    );

    forAllSystems = function:
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ] (system: function (mkPkgs system));
  in {
    packages = forAllSystems (pkgsSet: import ./packages { inherit self; inherit (pkgsSet) pkgs pkgs-23_05; } );

    nixosModules = (import ./modules) self;
  };
}
