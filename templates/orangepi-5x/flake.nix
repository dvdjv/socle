{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    socle = {
      url = "github:dvdjv/socle";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {self, nixpkgs, socle, ...}: {
    nixosConfigurations = {
      orangepi5 = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          socle.nixosModules.orangepi-5
          ./confguration.nix
          ./orangepi5.nix
        ];
      };

      orangepi5plus = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          socle.nixosModules.orangepi-5-plus
          ./confguration.nix
          ./orangepi5plus.nix
        ];
      };
    };
  };
}
