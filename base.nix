# Base configuration shared among all devices
{inputs, ...}: {
  imports = with inputs; [
    ./modules
    ./network
    ./pkgs
    ./programs
    ./system
  ];
}
