{
  description = "A collection of packages to support RK3588(S)-based SBCs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs = inputs @ { self, nixpkgs, ...}: let
    mkPkgs = system: (
      import nixpkgs {
        localSystem = system;
        crossSystem = "aarch64-linux";
      }
    );

    forAllSystems = function:
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ] (system: function (mkPkgs system));
  in {
    packages = forAllSystems (pkgs: import ./packages { inherit self pkgs; } );

    nixosModules = (import ./modules) self;

    checks = forAllSystems (pkgs: {
      orangepi-5 = (pkgs.nixos [
        self.nixosModules.orangepi-5
        { system.stateVersion = "24.11"; }
      ]).config.system.build.sdImage;

      orangepi-5-plus = (pkgs.nixos [
        self.nixosModules.orangepi-5-plus
        { system.stateVersion = "24.11"; }
      ]).config.system.build.sdImage;
    });

    templates = rec {
      default = orangepi-5x;
      orangepi-5x = {
        path = ./templates/orangepi-5x;
        description = "A template for Orange Pi 5 family of SBCs";
      };
    };
  };
}
