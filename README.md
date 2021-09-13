# deployarch
My archlinux installation and customization scripts.

Steps :
1) Boot the live archiso media
2) Install the dependencies
  pacman -S wget unzip
3) Download scripts
  wget https://github.com/alterelkt/deployarch/archive/main.zip
4) Extract scripts
  unzip main.zip
5) Make start.sh script executable and run
  chmod +x deployarch-main/start.sh
  deployarch-main/start.sh
6) Partition disk
7) Configure pre_chroot.sh script by changing partition names variable in the beggining and make script executable and run
  vim deployarch-main/pre_chroot.sh
    boot_partition=<your_boot_partition>
    swap_partition=<your_swap_partition>
    root_partition=<your_root_partition>
  chmod +x deployarch-main/pre_chroot.sh
  deployarch-main/pre_chroot.sh
 8) Chroot into new installation
 9) Follow instructions from scripts
