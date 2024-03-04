{ linuxManualConfig, fetchFromGitHub, ... }: linuxManualConfig rec {
  src = fetchFromGitHub {
    owner = "armbian";
    repo = "linux-rockchip";
    rev = "8cae9a3e884071996260905575b55136e2480f6b";
    hash = "sha256-9pp9OXRMY8RUq4Fn5AcYhiGeyXXDPRAm9fUVzQV5L2k=";
  };
  version = "5.10.160-armbian-rk35xx";
  modDirVersion = "5.10.160";
  extraMeta.branch = "5.10";
  configfile = ./config/linux-${version}.config;
  allowImportFromDerivation = true;
}
