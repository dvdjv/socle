{ ... }: {
  # You can set your timezone here
  # time.timeZone = "Europe/Dublin";

  nixpkgs = {
    # to build on aarch64 machine
    hostPlatform = { system = "aarch64-linux"; };

    # to build on x86_64 machine
    # hostPlatform = { system = "aarch64-linux"; };
    # buildPlatform = { system = "x86_64-linux"; };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  services.openssh.enable = true;

  users.users.nixos = {
    isNormalUser = true;
    password = "nixos";
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = "24.11";
}
