{ lib, mesa, fetchFromGitLab, ... }: let
  mesaP = mesa.override {
    galliumDrivers = ["panfrost" "swrast"];
    vulkanDrivers = ["swrast"];
  };
in mesaP.overrideAttrs {
    version = "24.1.0-devel";
    mesonFlags = (with lib; filter (opt: !(hasPrefix "-Dintel-clc" opt))  mesaP.mesonFlags) ++ [
      "-Dintel-clc=auto"
      "-Dintel-rt=disabled"
      "-Dgallium-vdpau=disabled"
      "-Dgallium-va=disabled"
      "-Dgallium-xa=disabled"
    ];
    src = fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "Mesa";
        repo = "mesa";
        rev = "5a852bd24cc10e08e42703751e7d1ba384b76e31";
        hash = "sha256-2aNZPphjTjZhLg4p2bJx/GPWhzZ+hnSnc8tYcuIU2mo=";
    };
}
