{ stdenv, stdenvNoCC, fetchFromGitHub, autoPatchelfHook, libdrm, wayland, libxcb, libX11, ... }: let
  src = fetchFromGitHub {
    owner = "JeffyCN";
    repo = "mirrors";
    rev = "ab3d91e3df2ef1c487c2d8f69daea1729668e428";
    hash = "sha256-VBk1D41we3re9qcjDurtnFZIduARNdwd6RnDir7Xr3o=";
  };
in {
  mali-firmware-g610-g21p0-01eac0 = stdenvNoCC.mkDerivation {
    pname = "mali-firmware";
    version = "g21p0-01eac0";
    dontBuild = true;
    dontFixup = true;
    compressFirmware = false;

    inherit src;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/firmware
      install --mode=755 firmware/g610/mali_csffw.bin $out/lib/firmware/

      runHook postInstall
    '';
  };

  libmali-valhall-g610-g13p0-x11-wayland-gbm = stdenv.mkDerivation rec {
    pname = "libmali-valhall-g610";
    version = "g13p0";
    variant = "x11-wayland-gbm";
    dontBuild = true;
    dontConfigure = true;

    inherit src;

    nativeBuildInputs = [ autoPatchelfHook ];
    buildInputs = [ stdenv.cc.cc.lib libdrm wayland libxcb libX11 ];

    preBuild = ''
      addAutoPatchelfSearchPath ${stdenv.cc.cc.lib}/aarch64-unknown-linux-gnu/lib
    '';

    installPhase = let
      libmaliFileName = "${pname}-${version}-${variant}.so";
    in ''
      runHook preInstall

      mkdir -p $out/lib
      mkdir -p $out/etc/OpenCL/vendors
      mkdir -p $out/share/glvnd/egl_vendor.d

      install --mode=755 lib/aarch64-linux-gnu/${libmaliFileName} $out/lib
      echo $out/lib/${libmaliFileName} > $out/etc/OpenCL/vendors/mali.icd
      cat > $out/share/glvnd/egl_vendor.d/60_mali.json << EOF
      {
        "file_format_version" : "1.0.0",
        "ICD" : {
          "library_path" : "$out/lib/${libmaliFileName}"
        }
      }
      EOF

      runHook postInstall
    '';
  };
}
