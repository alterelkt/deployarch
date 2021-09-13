#!/bin/bash

user_name='aman'
user_keymap='us'
system_timezone='Asia/Kolkata'
system_hostname='arch'

#change to root's home directory
cd ~
# set timezone
ln -sf /usr/share/zoneinfo/${system_timezone} /etc/localtime
# configure clock
hwclock --systohc
# remove '#' of comment on line 177 to make locale 'us' 
sed -i '177s/.//' /etc/locale.gen
locale-gen
# set locale and keymap
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=${user_keymap}" >> /etc/vconsole.conf
# set hostname
echo "${system_hostname}" >> /etc/hostname
# configure hosts file
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1 localhost" >> /etc/hosts
echo "127.0.1.1 ${system_hostname}.localdomain ${system_hostname}" >> /etc/hosts
# prompt for root user password
echo "Enter root password :"
passwd

# install basic utilities and drivers
pacman -Syy grub grub-btrfs efibootmgr os-prober btrfs-progs snapper base-devel linux-headers dialog sudo networkmanager wpa_supplicant bluez bluez-utils mtools dosfstools xdg-user-dirs xdg-utils bash-completion rsync alsa-utils pulseaudio pulseaudio-alsa pulseaudio-bluetooth mesa xf86-video-intel 
#nvidia nvidia-utils nvidia-settings

# enable services to run automatically after boot
systemctl enable NetworkManager
systemctl enable bluetooth

# add user and configure previlages
useradd -m ${user_name}
echo "Enter user ${user_name}'s password :"
passwd ${user_name}
usermod -aG wheel,audio,video ${user_name}
echo "${user_name} ALL=(ALL) ALL" >> /etc/sudoers.d/${user_name}

# copy script files to home of root user
cp -r ~/deployarch-main /mnt/home/${user_name}/

# install GRUB bootloader
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

printf "\n \n \n In the start 'MODULES=()' to 'MODULES=(btrfs)' \n In below down 'HOOKS=(...block filesystem...)' to 'HOOKS=(...block encrypt filesystem...)'\n"
while true; do
    read -p "Press Y/y to edit mkinitcpio.conf " yn
    case $yn in
        [Yy]* ) vim /etc/mkinitcpio.conf ; break;;
        [Nn]* ) exit;;
    esac
done
mkinitcpio -p linux

read -p "Enter root partition (eg. sda3) " root_partition
root_UUID=$(blkid -s UUID -o value /dev/${root_partition})
printf '\n \n \n In the start "GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"" to "GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet cryptdevice=UUID=${root_UUID}:cryptroot root=/dev/mapper/cryptroot"" \n for virtual machine only "GRUB_LINUX_CMDLINE_DEFAULT="loglevel=3 quiet cryptdevice=UUID=${root_UUID}:cryptroot root=/dev/mapper/cryptroot video=1920x1080"" \n \n \n Go to last line of the file to copy above syntax \n'

echo "#loglevel=3 quiet cryptdevice=UUID=${root_UUID}:cryptroot root=/dev/mapper/cryptroot" >> /etc/default/grub
while true; do
    read -p "Press Y/y to edit grub " yn
    case $yn in
        [Yy]* ) vim /etc/default/grub ; break;;
        [Nn]* ) exit;;
    esac
done
grub-mkconfig -o /boot/grub/grub.cfg
