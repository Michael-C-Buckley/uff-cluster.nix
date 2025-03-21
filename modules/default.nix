{inputs, ...}: let 
  customModules = with inputs.nixos-modules.nixosModules; [
    nfs zfs
  ];
in {
  imports = [
    ./corosync.nix
    ./filesystems.nix
    ./hardware.nix
    ./options.nix
    ./podman.nix
  ] ++ customModules;

  custom.uff.enusb1.ipv4.prefixLength = 27;
  features.podman.enable = true;
  services.glusterfs.enable = true;
}
