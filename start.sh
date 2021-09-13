#!/bin/bash

# date time
timedatectl set-ntp true

# update pacman database


# show block devices
lsblk

# next objective
printf "gdisk /dev/vda \n n +300M ef00 (efipartiton) \n n +2G 8200 (Swappartition) \n n \n w \n y \n \n \n after partitioning disks run pre_chroot.sh\n"