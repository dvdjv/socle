self: rec {
  orangepi-5-base = { lib, pkgs, config, ... }: let
    inherit ((import ./lib) { inherit lib; }) mkOverlayOption;
    mkRockchipOption = mkOverlayOption "rockchip/overlay";
    sbcCfg = config.sbc;
  in {
    imports = with self.inputs; [
      "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
      ./util/fdt-overlays.nix
    ];

    options.sbc = {
      hardware = {
        led.disabled = mkRockchipOption {
          overlay = "rk3588-disable-led.dtbo";
          description = "Disable LED";
        };
      };
    };

    config = {
      boot = {
        supportedFilesystems = lib.mkForce [
          "vfat"
          "fat32"
          "exfat"
          "ext4"
          "btrfs"
        ];

        kernelParams = [
          "console=ttyFIQ0,1500000n8"
        ];

        initrd.includeDefaultModules = lib.mkForce false;
        initrd.availableKernelModules = lib.mkForce [];

        kernelPackages = pkgs.linuxPackagesFor self.packages.${pkgs.stdenv.buildPlatform.system}.linux-xunlong-rk35xx;
      };

      hardware = {
        deviceTree.enabledOverlays = sbcCfg.hardware.led.disabled;
        opengl.enable = true;
        opengl.extraPackages = [ self.packages.${pkgs.stdenv.buildPlatform.system}.libmali-valhall-g610 ];
        firmware = lib.mkForce (with pkgs; [
          self.packages.${pkgs.stdenv.buildPlatform.system}.orangepi-firmware
          self.packages.${pkgs.stdenv.buildPlatform.system}.mali-firmware-g610
        ]);
      };
    };
  };

  orangepi-5 = { pkgs, ... }: {
    
    imports = [ orangepi-5-base ];

    config.sdImage = {
      firmwarePartitionOffset = 16;
      postBuildCommands = "dd if=${self.packages.${pkgs.stdenv.buildPlatform.system}.u-boot-orangepi-5}/u-boot-rockchip.bin of=$img seek=64 conv=notrunc";
    };
  };

  orangepi-5-plus = { pkgs, ... }: {
    imports = [ orangepi-5-base ];

    sdImage = {
      firmwarePartitionOffset = 16;
      postBuildCommands = "dd if=${self.packages.${pkgs.stdenv.buildPlatform.system}.u-boot-orangepi-5-plus}/u-boot-rockchip.bin of=$img seek=64 conv=notrunc";
    };
  };
}
