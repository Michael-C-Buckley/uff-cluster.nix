_: {
  imports = [
    ./boot.nix
    ./nix.nix
    ./security.nix
    ./time.nix
    ./users.nix
  ];

  system.stateVersion = "25.05";
  environment.enableAllTerminfo = true;
  time.timeZone = "America/New_York";

  nixpkgs = {
    hostPlatform = "x86_64-linux";
    config.allowUnfree = true;
  };
}
