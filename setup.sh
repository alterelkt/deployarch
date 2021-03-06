#!/bin/bash

timedatectl set-ntp true

lsblk
read -p "Enter device (eg. sda) " device_to_install
gdisk /dev/${device_to_install}
boot_partition=${device_to_install}1
swap_partition=${device_to_install}2
root_partition=${device_to_install}3

mkfs.fat -F32 /dev/${boot_partition}
mkswap /dev/${swap_partition}

# enable swap
swapon /dev/${swap_partition}

# create encrypted partition
echo "Create encrypted partition, enter new passphrase :"
cryptsetup luksFormat /dev/${root_partition}

# open encrypted partition as name cryptroot
echo "Open encrypted partition, enter passphrase :"
cryptsetup luksOpen /dev/${root_partition} cryptroot

# make btrfs root
mkfs.btrfs /dev/mapper/cryptroot

# mount partition and create subvolumes and unmount partition
mount /dev/mapper/cryptroot /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@var_log
umount /mnt

# remount partition with flags
mount -o noatime,compress=lzo,space_cache=v2,discard=async,subvol=@ /dev/mapper/cryptroot /mnt
mkdir -p /mnt/{boot,home,.snapshots,var}
mkdir /mnt/var/log
mount -o noatime,compress=lzo,space_cache=v2,discard=async,subvol=@home /dev/mapper/cryptroot /mnt/home
mount -o noatime,compress=lzo,space_cache=v2,discard=async,subvol=@snapshots /dev/mapper/cryptroot /mnt/.snapshots
mount -o noatime,compress=lzo,space_cache=v2,discard=async,subvol=@var_log /dev/mapper/cryptroot /mnt/var/log
mount /dev/${boot_partition} /mnt/boot

# install base packages
pacstrap /mnt base linux linux-firmware intel-ucode btrfs-progs git wget unzip vim

# generate filesystem table
genfstab -U /mnt >> /mnt/etc/fstab

# copy script files to home of root user
cp -r ~/deployarch-main /mnt/root/

arch-chroot /mnt