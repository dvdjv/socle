{ fetchFromGitHub, stdenv, autoPatchelfHook, libdrm, ... }: stdenv.mkDerivation {
    pname = "libmali";
    version = "g610-g6p0";
    dontBuild = true;
    dontConfigure = true;

    src = fetchFromGitHub {
        owner = "JeffyCN";
        repo = "mirrors";
        rev = "ab3d91e3df2ef1c487c2d8f69daea1729668e428";
        hash = "sha256-VBk1D41we3re9qcjDurtnFZIduARNdwd6RnDir7Xr3o=";
    };
    nativeBuildInputs = [ autoPatchelfHook ];
    buildInputs = [ stdenv.cc.cc.lib libdrm ];

    installPhase = ''
        runHook preInstall

        mkdir -p $out/lib
        mkdir -p $out/etc/OpenCL/vendors
        mkdir -p $out/share/glvnd/egl_vendor.d
        install --mode=555 lib/aarch64-linux-gnu/libmali-valhall-g610-g6p0-gbm.so $out/lib
        echo $out/lib/libmali-valhall-g610-g6p0-gbm.so > $out/etc/OpenCL/vendors/mali.icd
        cat > $out/share/glvnd/egl_vendor.d/40_mali.json << EOF
        {
          "file_format_version" : "1.0.0",
          "ICD" : {
            "library_path" : "$out/lib/libmali-valhall-g610-g6p0-gbm.so"
          }
        }
        EOF

        runHook postInstall
    '';
}
