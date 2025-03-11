# Base configuration shared among all devices
{inputs, ...}: {
  imports = with inputs; [
    inputs.michael-home.nixosModules.hjem.default
    ./modules
    ./network
    ./pkgs
    ./programs
    ./system
  ];
}
