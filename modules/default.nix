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

        customOverlays = mkOption {
          type = types.attrsOf (types.submodule {
            options = {
              overlay = mkOption {
                type = types.str;
                description = "Name of the device tree overlay (without path or extension).";
              };
              inverse = mkOption {
                type = types.bool;
                default = false;
                description = "Whether the overlay is disabled when enabled (e.g., for disable-LED overlays).";
              };
              description = mkOption {
                type = types.str;
                default = "";
                description = "Description of the custom overlay.";
              };
            };
          });
          default = {};
          description = ''
            Additional hardware overlays to make available for the board.
            These are merged with the predefined hardware.available overlays.
            Ensure the corresponding .dtbo files are included in hardware.firmware,
            e.g., by adding a package that installs them to /rockchip/overlay.
          '';
        };

        enabled = builtins.mapAttrs (_: args: mkRockchipOption args)
          # Merge predefined and custom overlays
          (lib.mergeAttrs boardCfg.hardware.available boardCfg.hardware.customOverlays);
      };
    };

    config = {
      assertions = lib.mapAttrsToList (name: _: {
        assertion = ! (lib.hasAttr name boardCfg.hardware.available) || (boardCfg.hardware.customOverlays.${name}.overlay == boardCfg.hardware.available.${name}.overlay);
        message = "Custom overlay '${name}' overrides a predefined overlay with a different configuration, which may be unintended.";
      }) boardCfg.hardware.customOverlays;

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
        graphics.enable = true;
        graphics.extraPackages = [ self.packages.${pkgs.stdenv.buildPlatform.system}.libmali-valhall-g610 ];
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
      uBootPackage = pkgs.ubootOrangePi5;

      hardware.available = {
        led = {
          overlay = "rk3588-disable-led";
          inverse = true;
          description = "Whether to disable LED";
        };

        can1-m1 = { overlay = "rk3588-can1-m1"; };
        can2-m1 = { overlay = "rk3588-can2-m1"; };

        dmc = { overlay = "rk3588-dmc"; };

        i2c1-m2 = { overlay = "rk3588-i2c1-m2"; };
        i2c1-m4 = { overlay = "rk3588-i2c1-m4"; };
        i2c3-m0 = { overlay = "rk3588-i2c3-m0"; };
        i2c5-m3 = { overlay = "rk3588-i2c5-m3"; };

        lcd1 = { overlay = "rk3588-lcd1"; };
        lcd2 = { overlay = "rk3588-lcd2"; };

        ov13850-c1 = { overlay = "rk3588-ov13850-c1"; };
        ov13850-c2 = { overlay = "rk3588-ov13850-c2"; };
        ov13850-c3 = { overlay = "rk3588-ov13850-c3"; };
        ov13855-c1 = { overlay = "rk3588-ov13855-c1"; };
        ov13855-c2 = { overlay = "rk3588-ov13855-c2"; };
        ov13855-c3 = { overlay = "rk3588-ov13855-c3"; };

        pwm0-m1 = { overlay = "rk3588-pwm0-m1"; };
        pwm1-m1 = { overlay = "rk3588-pwm1-m1"; };
        pwm1-m2 = { overlay = "rk3588-pwm1-m2"; };
        pwm3-m0 = { overlay = "rk3588-pwm3-m0"; };
        pwm3-m2 = { overlay = "rk3588-pwm3-m2"; };
        pwm13-m2 = { overlay = "rk3588-pwm13-m2"; };
        pwm14-m1 = { overlay = "rk3588-pwm14-m1"; };
        pwm15-m2 = { overlay = "rk3588-pwm15-m2"; };

        spi4-m0-cs1-spidev = { overlay = "rk3588-spi4-m0-cs1-spidev"; };

        ssd-sata0 = { overlay = "rk3588-ssd-sata0"; };
        ssd-sata2 = { overlay = "rk3588-ssd-sata2"; };

        uart0-m2 = { overlay = "rk3588-uart0-m2"; };
        uart1-m1 = { overlay = "rk3588-uart1-m1"; };
        uart3-m0 = { overlay = "rk3588-uart3-m0"; };
        uart4-m0 = { overlay = "rk3588-uart4-m0"; };

        wifi-ap6275p = { overlay = "rk3588-wifi-ap6275p"; };
        wifi-pcie = { overlay = "rk3588-wifi-pcie"; };
      };
    };
  };

  orangepi-5-plus = { pkgs, ... }: {
    imports = [ rk3588x-board ];

    board = {
      name = "Orange Pi 5 Plus";
      uBootPackage = pkgs.ubootOrangePi5Plus;

      hardware.available = {
        leds = {
          overlay = "rk3588-opi5plus-disable-leds";
          inverse = true;
          description = "Whether to disable LEDs";
        };

        can0-m0 = { overlay = "rk3588-can0-m0"; };
        can1-m0 = { overlay = "rk3588-can1-m0"; };

        dmc = { overlay = "rk3588-dmc"; };

        gc5035 = { overlay = "rk3588-opi5plus-gc5035"; };

        hdmi2-8k = { overlay = "rk3588-hdmi2-8k"; };
        hdmirx = { overlay = "rk3588-hdmirx"; };

        i2c2-m0 = { overlay = "rk3588-i2c2-m0"; };
        i2c2-m4 = { overlay = "rk3588-i2c2-m4"; };
        i2c4-m3 = { overlay = "rk3588-i2c4-m3"; };
        i2c5-m3 = { overlay = "rk3588-i2c5-m3"; };
        i2c8-m2 = { overlay = "rk3588-i2c8-m2"; };

        lcd = { overlay = "rk3588-opi5plus-lcd"; };

        ov13850 = { overlay = "rk3588-opi5plus-ov13850"; };
        ov13855 = { overlay = "rk3588-opi5plus-ov13855"; };

        pwm0-m0 = { overlay = "rk3588-pwm0-m0"; };
        pwm0-m2 = { overlay = "rk3588-pwm0-m2"; };
        pwm1-m0 = { overlay = "rk3588-pwm1-m0"; };
        pwm1-m2 = { overlay = "rk3588-pwm1-m2"; };
        pwm11-m0 = { overlay = "rk3588-pwm11-m0"; };
        pwm12-m0 = { overlay = "rk3588-pwm12-m0"; };
        pwm13-m0 = { overlay = "rk3588-pwm13-m0"; };
        pwm14-m0 = { overlay = "rk3588-pwm14-m0"; };
        pwm14-m2 = { overlay = "rk3588-pwm14-m2"; };

        spi0-m2-cs0-cs1-spidev = { overlay = "rk3588-spi0-m2-cs0-cs1-spidev"; };
        spi0-m2-cs0-spidev = { overlay = "rk3588-spi0-m2-cs0-spidev"; };
        spi0-m2-cs1-spidev = { overlay = "rk3588-spi0-m2-cs1-spidev"; };
        spi4-m1-cs0-cs1-spidev = { overlay = "rk3588-spi4-m1-cs0-cs1-spidev"; };
        spi4-m1-cs0-spidev = { overlay = "rk3588-spi4-m1-cs0-spidev"; };
        spi4-m1-cs1-spidev = { overlay = "rk3588-spi4-m1-cs1-spidev"; };
        spi4-m2-cs0-spidev = { overlay = "rk3588-spi4-m2-cs0-spidev"; };

        ssd-sata0 = { overlay = "rk3588-ssd-sata0"; };
        ssd-sata2 = { overlay = "rk3588-ssd-sata2"; };

        uart1-m1 = { overlay = "rk3588-uart1-m1"; };
        uart3-m1 = { overlay = "rk3588-uart3-m1"; };
        uart4-m2 = { overlay = "rk3588-uart4-m2"; };
        uart6-m1 = { overlay = "rk3588-uart6-m1"; };
        uart7-m2 = { overlay = "rk3588-uart7-m2"; };
        uart8-m1 = { overlay = "rk3588-uart8-m1"; };

        wifi-ap6275p = { overlay = "rk3588-wifi-ap6275p"; };
        wifi-pcie = { overlay = "rk3588-wifi-pcie"; };
      };
    };
  };
}
