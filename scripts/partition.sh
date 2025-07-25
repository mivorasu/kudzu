#!/bin/sh

set -e

# 设定分区路径
ROOT_PARTITION="/dev/nvme0n1p2"
BOOT_PARTITION="/dev/nvme0n1p1"

# 创建btrfs文件系统
mkfs.btrfs -f $ROOT_PARTITION
# mkfs.vfat -n BOOT $BOOT_PARTITION

# 挂载根分区并创建子卷
mount -t btrfs $ROOT_PARTITION /mnt
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/nix
# btrfs subvolume create /mnt/persist
btrfs subvolume create /mnt/log
btrfs subvolume create /mnt/swap

# 创建一个空的只读快照，可以在每次启动时回滚到这个快照
# btrfs subvolume snapshot -r /mnt/root /mnt/root-blank

umount /mnt

# 挂载子卷
mount -o subvol=root,compress=zstd,noatime $ROOT_PARTITION /mnt
mkdir /mnt/home
mount -o subvol=home,compress=zstd,noatime $ROOT_PARTITION /mnt/home
mkdir /mnt/nix
mount -o subvol=nix,compress=zstd,noatime $ROOT_PARTITION /mnt/nix
# mkdir /mnt/persist
# mount -o subvol=persist,compress=zstd,noatime $ROOT_PARTITION /mnt/persist
mkdir -p /mnt/var/log
mount -o subvol=log,compress=zstd,noatime $ROOT_PARTITION /mnt/var/log
mount -o subvol=swap,noatime $ROOT_PARTITION /mnt/swap

btrfs filesystem mkswapfile --size 4g --uuid clear /mnt/swap/swapfile

# 挂载引导分区
mkdir /mnt/boot
mount $BOOT_PARTITION /mnt/boot

# 生成NixOS配置文件
nixos-generate-config --root /mnt
