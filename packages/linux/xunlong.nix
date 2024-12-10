{ linuxManualConfig, fetchFromGitHub, ubootTools, ... }: (linuxManualConfig rec {
  src = fetchFromGitHub {
    owner = "orangepi-xunlong";
    repo = "linux-orangepi";
    rev = "752c0d0a12fdce201da45852287b48382caa8c0f";
    hash = "sha256-tVu/3SF/+s+Z6ytKvuY+ZwqsXUlm40yOZ/O5kfNfUYc=";
  };
  version = "6.1.43-xunlong-rk35xx";
  modDirVersion = "6.1.43";
  extraMeta.branch = "6.1";
  configfile = ./config/linux-${version}.config;
  allowImportFromDerivation = true;
}).overrideAttrs (old: {
  nativeBuildInputs = old.nativeBuildInputs ++ [ ubootTools ];
})
