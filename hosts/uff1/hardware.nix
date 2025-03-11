{...}: {
  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/4589-97E3";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };
  };

  swapDevices = [];
}
