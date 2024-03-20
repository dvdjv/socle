{ lib, darwin, mesa, fetchFromGitLab, ... }: let
  mesa = darwin.apple_sdk_11_0.callPackage (import ./mesa) {
    inherit (darwin.apple_sdk_11_0.frameworks) OpenGL;
    inherit (darwin.apple_sdk_11_0.libs) Xplugin;
  };
  mesaP = mesa.override {
    galliumDrivers = ["panfrost" "swrast"];
    vulkanDrivers = ["swrast"];
    enableOSMesa = false;
  };
in mesaP.overrideAttrs (_: {
    pname = "mesa-panfork";
    version = "23.0.0-panfork";
    patches = [];
    mesonFlags = with lib;
      filter (flag: !((hasPrefix "-Dandroid-libbacktrace" flag) || (hasPrefix "-Ddisk-cache-key" flag))) mesaP.mesonFlags ++
      [
        "-Dgles1=disabled"
      ];
    src = fetchFromGitLab {
      owner = "panfork";
      repo = "mesa";
      rev = "120202c675749c5ef81ae4c8cdc30019b4de08f4";
      hash = "sha256-4eZHMiYS+sRDHNBtLZTA8ELZnLns7yT3USU5YQswxQ0=";
    };
  })
