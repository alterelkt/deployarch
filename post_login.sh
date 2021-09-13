#!/bin/bash

# configure snapper
sudo umount /.snapshots
sudo rm -r /.snapshots
sudo snapper -c root create-config /
sudo btrfs subvolume delete /.snapshots
sudo mkdir /.snapshots
sudo mount -a
sudo chmod 750 /.snapshots
printf '"-> change ALLOW_USERS="" ->-> ALLOW_USERS="aman" -> down below # limits for timeline cleanup check archwiki for recommended values"'
while true; do
    read -p "Press Y/y to edit /etc/snapper/configs/root" yn
    case $yn in
        [Yy]* ) sudo vim /etc/snapper/configs/root ; break;;
        [Nn]* ) exit;;
        * ) echo "Press Y/y or N/n.";;
    esac
done
sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer

# install AUR
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# some yay packages
yay -S snap-pac-grub snapper-gui brave-bin

# backuping of boot partition
sudo mkdir /etc/pacman.d/hooks
sudo touch /etc/pacman.d/hooks/50-bootbackup.hook
sudo echo '[Trigger]' >> /etc/pacman.d/hooks/50-bootbackup.hook
sudo echo 'Operation = Upgrade' >> /etc/pacman.d/hooks/50-bootbackup.hook
sudo echo 'Operation = Install' >> /etc/pacman.d/hooks/50-bootbackup.hook
sudo echo 'Operation = Remove' >> /etc/pacman.d/hooks/50-bootbackup.hook
sudo echo 'Type = Path' >> /etc/pacman.d/hooks/50-bootbackup.hook
sudo echo 'Target = boot/*' >> /etc/pacman.d/hooks/50-bootbackup.hook
sudo echo '' >> /etc/pacman.d/hooks/50-bootbackup.hook
sudo echo '[Action]' >> /etc/pacman.d/hooks/50-bootbackup.hook
sudo echo 'Depends = rsync' >> /etc/pacman.d/hooks/50-bootbackup.hook
sudo echo 'Description = Backing up /boot...' >> /etc/pacman.d/hooks/50-bootbackup.hook
sudo echo 'When = PreTransaction' >> /etc/pacman.d/hooks/50-bootbackup.hook
sudo echo 'Exec = /usr/bin/rsync -a --delete /boot /.bootbackup' >> /etc/pacman.d/hooks/50-bootbackup.hook

printf '"[Trigger]\n
Operation = Upgrade\n
Operation = Install\n
Operation = Remove\n
Type = Path\n
Target = boot/*\n
\n
[Action]\n
Depends = rsync\n
Description = Backing up /boot...\n
When = PreTransaction\n
Exec = /usr/bin/rsync -a --delete /boot /.bootbackup\n
\n
\n Check if above snippet is in the /etc/pacman.d/hooks/50-bootbackup.hook"'

while true; do
    read -p "Press Y/y to run 'sudo vim /etc/pacman.d/hooks/50-bootbackup.hook'" yn
    case $yn in
        [Yy]* ) sudo vim /etc/pacman.d/hooks/50-bootbackup.hook ; break;;
        [Nn]* ) exit;;
        * ) echo "Press Y/y or N/n.";;
    esac
done

# snapper snapshot gui read and execute permissions
sudo chmod a+rx /.snapshots
sudo chown :aman /.snapshots

# post install packages
sudo pacman -S \ 
    xorg xorg-xrandr qtile \ 
    alacritty zsh \ 
    dmenu feh picom trayer \ 
    htop p7zip unzip \ 
    qutebrowser wget \ 
    ffmpeg ffmpeg-thumbnailer handbrake \ 
    mpv \ 
    krita inkscape imagemagick
    #virtualbox
printf "Script post_login.sh executed completely.\n \n \n Enjoy!"