{ self, pkgs, ... }: let
  u-boot-orangepi-rk35xx = (pkgs.callPackage ./uboot.nix {});

in rec {
  linux-xunlong-rk35xx = linux-xunlong-rk35xx-6_1;
  linux-xunlong-rk35xx-6_1 = (pkgs.callPackage ./linux/xunlong.nix {});

  orangepi-firmware = orangepi-firmware-2024_01_24;
  orangepi-firmware-2024_01_24 = (pkgs.callPackage ./orangepi-firmware.nix {});

  mali-firmware-g610 = mali-firmware-g610-g21p0-01eac0;
  libmali-valhall-g610 = libmali-valhall-g610-g13p0;
  libmali-valhall-g610-g13p0 = libmali-valhall-g610-g13p0-x11-wayland-gbm;

  inherit (pkgs.callPackage ./libmali.nix {})
    mali-firmware-g610-g21p0-01eac0
    libmali-valhall-g610-g13p0-x11-wayland-gbm;
}
