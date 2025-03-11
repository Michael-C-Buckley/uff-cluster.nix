# Base configuration shared among all devices
{inputs, ...}: {
  imports = with inputs; [
    ./modules
    ./pkgs
    ./programs
    ./system
  ];
}
