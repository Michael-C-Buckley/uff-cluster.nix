{...}: {
  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/8E01-5577";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };
  };

  swapDevices = [];
}
