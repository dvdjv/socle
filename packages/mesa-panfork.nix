{ mesa, fetchFromGitLab, ... }: (mesa.override {
    galliumDrivers = ["panfrost" "swrast"];
    vulkanDrivers = ["swrast"];
}).overrideAttrs (_: {
    pname = "mesa-panfork";
    version = "23.0.0-panfork";
    src = fetchFromGitLab {
        owner = "panfork";
        repo = "mesa";
        rev = "120202c675749c5ef81ae4c8cdc30019b4de08f4"; # branch: csf
        hash = "sha256-4eZHMiYS+sRDHNBtLZTA8ELZnLns7yT3USU5YQswxQ0=";
    };
    patches = [];
})