# socle
[Wikipedia](https://en.wikipedia.org/wiki/Socle_(architecture)): In architecture, a socle is a short plinth used to support a pedestal, sculpture, or column.

A collection of packages and modules to support NixOS on single board computers based on the RK3588(S) SoC. Currently the following boards are supported:
* Orange Pi 5
* Orange Pi 5 Plus

## Features
* Linux Kernel 6.1
* OpenCL 3.0 with libmali
* Options to enable device tree overlays

## Usage
Socle provides a template you can use as a base for your new NixOS installation.

### Building SD image
1. Clone the template
   ```
   nix flake new --template github:dvdjv/socle nixos
   ```
   This will create a directory named `nixos` with the system configuration in it.
2. Edit the configuration

   Open the file `nixos/flake.nix` in a text editor and locate the following lines:
   ```
   # socle.nixosModules.orangepi-5
   # socle.nixosModules.orangepi-5-plus
   ```
   Uncomment one of the lines depending on the model of your board. You can tune other options as well. Consult the [NixOS manual](https://nixos.org/manual/nixos/stable/options) for the list of possible options.
4. Build the image
   ```
   nix build .#nixosConfigurations.nixos.sdImage
   ```
5. Flash the image
   ```
   zstdcat result/sd-image/nixos-sd-image-23.11pre-git-aarch64-linux.img.zst | dd of=/dev/sdX bs=1M
   ```
   Where `/dev/sdX` is the device node corresponding to your SD card.

### Device Tree Overlays
Device tree overlays can be enableb by means of the `board.hardware.enabled` option. Some examples are given in the flake templates. The full list of the hardware options is available in the source code of the board specific modules.
