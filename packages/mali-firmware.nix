{ fetchFromGitHub, stdenvNoCC, ... }: stdenvNoCC.mkDerivation {
    pname = "mali-firmware";
    version = "g21p0-01eac0";
    dontBuild = true;
    dontFixup = true;
    compressFirmware = false;

    src = fetchFromGitHub {
        owner = "JeffyCN";
        repo = "mirrors";
        rev = "ab3d91e3df2ef1c487c2d8f69daea1729668e428";
        hash = "sha256-VBk1D41we3re9qcjDurtnFZIduARNdwd6RnDir7Xr3o=";
    };

    installPhase = ''
        runHook preInstall

        mkdir -p $out/lib/firmware
        install --mode=555 firmware/g610/mali_csffw.bin $out/lib/firmware/

        runHook postInstall
    '';
}
