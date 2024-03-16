self: rec {
  rk3588x-board = { lib, pkgs, config, ... }: let
    inherit ((import ./lib) { inherit lib; }) mkOverlayOption;
    mkRockchipOption = mkOverlayOption "rockchip/overlay";

    boardCfg = config.board;
  in {
    imports = with self.inputs; [
      "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
      ./util/fdt-overlays.nix
    ];

    options.board = with lib; {
      name = mkOption {
        type = types.str;
        internal = true;
        readOnly = true;
      };

      uBootPackage = mkOption {
        type = types.package;
        internal = true;
        readOnly = true;
      };

      hardware = {
        available = mkOption {
          type = types.attrs;
          internal = true;
          readOnly = true;
        };

        enabled = builtins.mapAttrs (_: args: mkRockchipOption args) boardCfg.hardware.available;
      };
    };

    config = {
      board.hardware.available = {
        led = {
          overlay = "rk3588-disable-led";
          inverse = true;
          description = "Whether to disable LED";
        };

        wifi-ap6275p = { overlay = "rk3588-wifi-ap6275p"; };
      };
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
      
      sdImage = {
        firmwarePartitionOffset = 16;
        postBuildCommands = "dd if=${boardCfg.uBootPackage}/u-boot-rockchip.bin of=$img seek=64 conv=notrunc";
      };

      hardware = {
        deviceTree.enabledOverlays = with builtins; concatLists (attrValues boardCfg.hardware.enabled);
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
    imports = [ rk3588x-board ];

    board = {
      name = "Orange Pi 5";
      uBootPackage = self.packages.${pkgs.stdenv.buildPlatform.system}.u-boot-orangepi-5;
    };
  };

  orangepi-5-plus = { pkgs, ... }: {
    imports = [ rk3588x-board ];

    board = {
      name = "Orange Pi 5 Plus";
      uBootPackage = self.packages.${pkgs.stdenv.buildPlatform.system}.u-boot-orangepi-5-plus;
    };
  };
}
