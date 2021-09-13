#!/bin/bash

# modify mkinitcpio.conf
printf "-> In the start MODULES=() ->-> MODULES=(btrfs) \n-> In below down HOOKS=(...block filesystem...fsck) ->-> HOOKS=(...block encrypt filesystem...)"
while true; do
    read -p "Press Y/y to edit mkinitcpio.conf" yn
    case $yn in
        [Yy]* ) vim /etc/mkinitcpio.conf ; break;;
        [Nn]* ) exit;;
        * ) echo "Press Y/y or N/n.";;
    esac
done
while true; do
    read -p "Press Y/y to run 'mkinitcpio -p linux'" yn
    case $yn in
        [Yy]* ) mkinitcpio -p linux ; break;;
        [Nn]* ) exit;;
        * ) echo "Press Y/y or N/n.";;
    esac
done
printf "Script mkinitcpio_tutorial.sh executed completely.\n \n \n Run the script grub_tutorial.sh"