# ZFS Install Script for the cluster

# Wipe the NVMe
wipefs -a /dev/nvme0n1
sgdisk --zap-all /dev/nvme0n1
# Wipe the SATA SDD
wipefs -a /dev/sda
sgdisk --zap-all /dev/sda

# Put boot on the NVMe then fill the rest with ZFS
sgdisk -n1:1M:+1G -t1:EF00 -c1:"EFI System" /dev/nvme0n1
sgdisk -n2:0:0 -t2:BF01 -c2:"ZFS Pool" /dev/nvme0n1

# Format the boot partition
mkfs.vfat -F32 /dev/nvme0n1p1

# Create the pool on the drive, use reasonable settings and allow multihost
zpool create -o ashift=12 \
  -O compression=zstd \
  -O atime=off \
  -O xattr=sa \
  -O acltype=posixacl \
  -O dnodesize=auto \
  -O normalization=formD \
  -O mountpoint=none \
  rpool /dev/nvme0n1p2

# Allow it to be read by any host
zpool set multihost=on rpool

# This create the zvols used in this cluster
zfs create -o mountpoint=none rpool/root
zfs create -o mountpoint=legacy rpool/root/nixos
zfs create -o mountpoint=legacy rpool/root/nix
zfs create -o mountpoint=legacy rpool/root/home
zfs create -o mountpoint=legacy rpool/root/gluster

# Mount the drives and prepare for the install
mount -t zfs rpool/root/nixos /mnt
mkdir -p /mnt/{nix,home,boot,data/gluster,etc/nixos}
mount -t zfs rpool/root/nix /mnt/nix
mount -t zfs rpool/root/home /mnt/home
mount -t zfs rpool/root/gluster /mnt/data/gluster
mount /dev/nvme0n1p1 /mnt/boot

# Clone this Repo
git clone https://github.com/Michael-C-Buckley/uff-cluster.nix.git

## ADD DEPLOY KEY FOR SECRETS