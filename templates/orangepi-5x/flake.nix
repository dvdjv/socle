{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    socle = {
      url = "github:dvdjv/socle";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {self, nixpkgs, socle, ...}: let
    mkOrangePi5xConfig =  boardModule: nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };

        modules = [
          socle.nixosModules.orangepi-5
          ./confguration.nix
          boardModule
        ];
    };

  in {
    nixosConfigurations = {
      orangepi5     = mkOrangePi5xConfig ./orangepi5.nix;
      orangepi5plus = mkOrangePi5xConfig ./orangepi5plus.nix;
    };
  };
}
