{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    socle = {
      url = "github:dvdjv/socle/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {self, nixpkgs, socle, ...}: let
    pkgs = import nixpkgs {
      # Change localSystem to aarch64-linux and remove crossSystem if you are going to use this configuration on your SBC
      localSystem = "x86_64-linux";
      crossSystem = "aarch64-linux";
    };
  in {
    nixosConfigurations = {
      nixos = pkgs.nixos [
        # Uncomment one of the below lines depending on your board
        # socle.nixosModules.orangepi-5
        # socle.nixosModules.orangepi-5-plus

        {
          # You can set your timezone here
          # time.timeZone = "Europe/Dublin";

          # Device tree overlays can be enabled here
          hardware.deviceTree.enabledOverlays = [
            # "rockchip/overlay/rk3588-disable-led.dtbo"
            # "rockchip/overlay/rk3588-wifi-ap6275p.dtbo"
          ];

          nix.settings.experimental-features = [ "nix-command" "flakes" ];

          networking.hostName = "orangepi5";
          services.openssh.enable = true;

          users.users.nixos = {
            isNormalUser = true;
            password = "nixos";
            extraGroups = [ "wheel" ];
          };

          system.stateVersion = "23.11";
        }
      ];
    };
  };
}