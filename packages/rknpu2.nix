{ stdenv, fetchFromGitHub, ... }: let
  src = fetchFromGitHub {
    owner = "rockchip-linux";
    repo = "rknpu2";
    rev = "5adf7c1bd17e169e9880ccdf3b49adde925ab7f9";
    hash = "sha256-9szvZmMreyuigeAUe8gIQgBzK/f9c9IgsIUAuHNguRU=";
  };
in stdenv.mkDerivation {
    pname = "rknpu2-rk3588";
    version = "1.5.2";
    dontConfigure = true;

    inherit src;

    preBuild = ''
      addAutoPatchelfSearchPath ${stdenv.cc.cc.lib}/aarch64-unknown-linux-gnu/lib
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib
      install --mode=755 runtime/RK3588/Linux/librknn_api/aarch64/librknnrt.so $out/lib
      ln -s $out/lib/librknnrt.so $out/lib/librknn_api.so

      runHook postInstall
    '';
  }