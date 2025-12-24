{ stdenv, fetchFromGitHub, cmake, ... }: stdenv.mkDerivation rec {
  pname = "rkmpp";
  version = "1.0.8";
  nativeBuildInputs = [ cmake ];
  patches = [ ./pkgconfig.patch ];

  src = fetchFromGitHub {
    owner = "rockchip-linux";
    repo = "mpp";
    rev = version;
    hash = "sha256-y1vWGz7VjwL02klPQWwoIh5ExpvS/vsDUHcMtMznVcI=";
  };
}
