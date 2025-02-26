{ stdenv, fetchFromGitHub, autoPatchelfHook, ... }: let
  src = fetchFromGitHub {
    owner = "airockchip";
    repo = "rknn-toolkit2";
    rev = "a8dd54d41e92c95b4f95780ed0534362b2c98b92";
    hash = "sha256-k0euxjuVIbWNmfV17vku/rK5zp6NVAQCbcVcazOFiQI=";
  };
in stdenv.mkDerivation {
    pname = "librknnrt-rk3588";
    version = "2.3.0";
    dontConfigure = true;

    inherit src;

    nativeBuildInputs = [ autoPatchelfHook ];
    buildInputs = [ stdenv.cc.cc.lib ];
    outputs = [ "out" "dev" ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib
      install --mode=755 rknpu2/runtime/Linux/librknn_api/aarch64/librknnrt.so $out/lib
      mkdir -p $dev/include
      install --mode=644 rknpu2/runtime/Linux/librknn_api/include/rknn_api.h $dev/include
      install --mode=644 rknpu2/runtime/Linux/librknn_api/include/rknn_custom_op.h $dev/include
      install --mode=644 rknpu2/runtime/Linux/librknn_api/include/rknn_matmul_api.h $dev/include

      runHook postInstall
    '';
  }