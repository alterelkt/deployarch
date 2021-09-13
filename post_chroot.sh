#!/bin/bash

# set timezone
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
# configure clock
hwclock --systohc
# remove '#' of comment on line 177 to make locale 'us' 
sed -i '177s/.//' /etc/locale.gen
locale-gen
# set locale and keymap
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=us" >> /etc/vconsole.conf
# set hostname
echo "archbtrfs" >> /etc/hostname
# configure hosts file
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1 localhost" >> /etc/hosts
echo "127.0.1.1 archbtrfs.localdomain archbtrfs" >> /etc/hosts
# prompt for root user password
echo "Enter root password :"
passwd

# install basic utilities and drivers
pacman -S grub grub-btrfs efibootmgr os-prober btrfs-progs snapper base-devel linux-headers dialog sudo networkmanager wpa_supplicant bluez bluez-utils mtools dosfstools xdg-user-dirs xdg-utils bash-completion rsync acpi alsa-utils pulseaudio pulseaudio-alsa pulseaudio-bluetooth mesa xf86-video-intel nvidia nvidia-utils nvidia-settings

# enable services to run automatically after boot
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable acpid

# add user "aman" and configure previlages
useradd -m aman
echo "Enter user aman's password :"
passwd aman
usermod -aG wheel,audio,video,libvirt aman
echo "aman ALL=(ALL) ALL" >> /etc/sudoers.d/aman

# install GRUB bootloader
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

printf "Script post_chroot executed completely.\n \n \n Run the script mkinitcpio_tutorial.sh"