#!/bin/bash

# make scripts executable
chmod +x init.sh
chmod +x pre_chroot.sh
chmod +x post_chroot.sh
chmod +x mkinitcpio_tutorial.sh
chmod +x grub_tutorial.sh
chmod +x post_login.sh

echo "making all scripts executable..."
printf "Scripts shall be executed in following sequence : \n -> init.sh \n -> pre_chroot.sh \n -> post_chroot.sh \n -> mkinitcpio_tutorial.sh \n -> grub_tutorial.sh \n -> post_login.sh"