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

          # Hardware can be turned on and off here
          board.hardware.enabled = {
            # If you are useing Orange Pi 5, uncomment the line below to turn the LED off
            # led = false;

            # If you are using Orange Pi 5 Plus, uncomment the line below to turn the LEDs off
            # leds = false;

            # Uncomment the line below to turn on the AP6275P Wi-Fi module
            # wifi-ap6275p = true;
          };

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