# socle
[Wikipedia](https://en.wikipedia.org/wiki/Socle_(architecture)): In architecture, a socle is a short plinth used to support a pedestal, sculpture, or column.

A collection of packages and modules to support NixOS on single-board computers based on the RK3588(S) SoC. Currently, the following boards are supported:
* Orange Pi 5
* Orange Pi 5 Plus

## Features
* Linux Kernel 6.1
* OpenCL 3.0 with libmali
* Options to enable device tree overlays

## Usage
Socle provides a template you can use as a base for your new NixOS installation.

### Building an SD Image
The easiest way to build an image is to use the provided flake template. The template contains NixOS configurations for Orange Pi 5 and Orange Pi 5 Plus.

1. Clone the template:
   ```
   nix flake new --template github:dvdjv/socle nixos
   ```
   This will create a directory named `nixos` with the system configurations in it.
2. (Optional) Edit the configuration:
   
   Open the file `nixos/configuration.nix` in a text editor. To change the default user credentials, locate the following lines:
   ```
   users.users.nixos = {
     isNormalUser = true;
     password = "nixos";
     extraGroups = [ "wheel" ];
   };
   ```
   Adjust the username, password, and groups as you see fit. To change the timezone, locate the following lines:
   ```
   # You can set your timezone here
   # time.timeZone = "Europe/Dublin";
   ```
   Uncomment the timezone option and insert your timezone.
   
   You can tune other options as well. Consult the [NixOS manual](https://nixos.org/manual/nixos/stable/options) for the list of possible options.
   Board-specific options are set in the files `orangepi5.nix` and `orangepi5plus.nix`. Notice, that the default network name differs between the boards.
4. Build the image

   On a `aarch64-linux` machine:
   ```
   nix build .#nixosConfigurations.orangepi5.config.system.build.sdImage
   ```
   to build an Orange Pi 5 image; or:
   ```
   nix build .#nixosConfigurations.orangepi5plus.config.system.build.sdImage
   ```
   to build an Orange Pi 5 Plus image.

   On a `x86_64-linux` machine:

   Cross compilation does not use the binary pachage cache and is prone to errors. It is recommended to use a `aarch64-linux` machine instead.

   Locate the following lines in `configuration.nix`
   ```
   # to build on aarch64 machine
   hostPlatform = { system = "aarch64-linux"; };

   # to build on x86_64 machine
   # hostPlatform = { system = "aarch64-linux"; };
   # buildPlatform = { system = "x86_64-linux"; };
   ```
   and change it to
   ```
   # to build on aarch64 machine
   # hostPlatform = { system = "aarch64-linux"; };
   # to build on x86_64 machine
   hostPlatform = { system = "aarch64-linux"; };
   buildPlatform = { system = "x86_64-linux"; };
   ```
   Build the image as described above.
6. Flash the image:
   ```
   zstdcat result/sd-image/nixos-sd-image-23.11pre-git-aarch64-linux.img.zst | dd of=/dev/sdX bs=1M
   ```
   Replace `/dev/sdX` with the device node corresponding to your SD card.

### Device Tree Overlays
Device tree overlays can be enabled using the `board.hardware.enabled` option. Examples are provided in the flake templates. For a complete list of hardware options, refer to the board-specific modules in the source code.
