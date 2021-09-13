#!/bin/bash

# modify grub
blkid
read -p "Enter root partiton (eg. sda3) " root_partition
blkid -s UUID -o value /dev/${root_partition}
root_UUID=$(blkid -s UUID -o value /dev/${root_partition})
printf 'Copy the UUID of encrypted device (root partition) (/dev/vda3) (not partition /dev/mapper/cryptroot) as UUID=XXXX
 \n In the start "GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"" to "GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet cryptdevice=UUID=XXXX:cryptroot root=/dev/mapper/cryptroot"" \n 
for virtual machine only "GRUB_LINUX_CMDLINE_DEFAULT="loglevel=3 quiet cryptdevice=UUID=XXXX:cryptroot root=/dev/mapper/cryptroot video=1920x1080""
 \n \n \n Go to last line of the file to copy above syntax \n'

echo '#GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet cryptdevice=UUID=${root_UUID}:cryptroot root=/dev/mapper/cryptroot"' >> /etc/default/grub
while true; do
    read -p "Press Y/y to edit grub " yn
    case $yn in
        [Yy]* ) vim /etc/default/grub ; break;;
        [Nn]* ) exit;;
        * ) echo "Press Y/y or N/n.";;
    esac
done
while true; do
    read -p "Press Y/y to run 'grub-mkconfig -o /boot/grub/grub.cfg' " yn
    case $yn in
        [Yy]* ) grub-mkconfig -o /boot/grub/grub.cfg ; break;;
        [Nn]* ) exit;;
        * ) echo "Press Y/y or N/n.";;
    esac
done
printf "Script grub_tutorial.sh executed completely.\n \n \n Now type 'exit' and then 'reboot'\n then run post_login.sh \n"