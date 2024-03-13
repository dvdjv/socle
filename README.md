# socle
[Wikipedia](https://en.wikipedia.org/wiki/Socle_(architecture)): In architecture, a socle is a short plinth used to support a pedestal, sculpture, or column.

A Nix flake to support single board computers based on the RK3588(S) SoC. Currently the following boards are supported:
* Orange Pi 5
* Orange Pi 5 Plus

## Features
* Linux Kernel 6.1
* U-Boot 2024.01
* An option to enable/disable device tree overlays

## Usage
Use the following flake to build a SD image:
```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    socle = {
      url = "github:dvdjv/socle/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {self, nixpkgs, socle, ...}: {
    nixosConfigurations = {
      orangepi5 = nixpkgs.lib.nixosSystem {
        modules = [
          socle.nixosModules.orangepi-5

          {
            nixpkgs.buildPlatform.system = "x86_64-linux";

            services.openssh.enable = true;

            hardware.deviceTree.enabledOverlays = [
              # "rockchip/overlay/rk3588-disable-led.dtbo"
              # "rockchip/overlay/rk3588-wifi-ap6275p.dtbo"
            ];
            nix.settings.experimental-features = [ "nix-command" "flakes" ];

            networking.hostName = "orangepi5";

            users.users.nixos = {
              isNormalUser = true;
              password = "nixos";
              extraGroups = [ "wheel" ];
            };
          }
        ];
      };
    };
  };
}

```
Build the image with `nix build .#nixosConfigurations.orangepi5.config.system.build.sdImage`. For Orange Pi 5 Plus replace `socle.nixosModules.orangepi-5` with `socle.nixosModules.orangepi-5-plus`. You can turn device tree overlays on and off using the `hardware.deviceTree.enabledOverlays` option.
