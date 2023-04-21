#!/bin/bash
#variables and other setup
begind='notdone'
uidd='notdone'
kerneld='notdone'
doned='donenot'
sdr=$PWD
shopt -s lastpipe
#check if script is being run as root; abort if not
if [ "$EUID" = 0 ]; then 
  echo "This script should not be run as root"
  exit
fi
#start of script, asks for user confirmation before beginning process
echo Welcome to Archconfig!
echo If you have not read the .readme file on Github yet, please do so before continuing
echo "Enter 'start' to begin the installation process or 'stop' to abort"
while [ $begind != 'done' ]; do
    read begin
    case $begin in 
    start) 
        begind='done' ;;
    stop) 
        exit ;;
    *) echo "Invalid input" ;;
    esac
done
#asks for username and then checks /home for answer validity
#echo What is your username?
#while [ $uidd != 'done' ]; do
#    read uid
#    if [ -d /home/$uid ]; then
#        uidd="done"
#    else
#        echo Not a user
#    fi
#done
#asks what type of kernel is being used
echo Please enter your password
sudo echo "Are you using a version of the kernel other than the default? (y/n)"
echo Note that this includes linux-lts
echo If you do not know the answer to this, it is probably no.
while [ $kerneld != 'done' ]; do
    read kernel
    case $kernel in
    y) 
    kerneld='done' ;;
    n)
    kerneld='done' ;;
    *)
    echo Invalid input ;;
    esac
done
#begins installing packages after user confirmation
read -p "Press ENTER to begin installation
From now until completion you will not have to interact with the script"
#install vbox drivers
if [ $kernel = n ]; then
    sudo pacman -S --noconfirm virtualbox-host-modules-arch
    else
    sudo pacman -S --noconfirm virtualbox-host-dkms
fi
#pacman
yes | sudo pacman -S go nano devtools dkms xorg-server xorg-xapps cinnamon lightdm lightdm-slick-greeter os-prober xed xviewer brasero rhythmbox libgpod gst-libav kpat kmahjongg gnome-mines neofetch steam openssh bluez bluez-utils firefox-developer-edition virtualbox gnome-screenshot libreoffice-fresh gimp lutris libnotify speech-dispatcher hunspell-en_US networkmanager hexchat discord
#installing yay
cd ~
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -sri
rm -rf yay
#using yay to install other AUR packages
yes | yay -S --answerclean None --answerdiff None --answeredit None --answerupgrade None pamac-nosnap xplayer-plparser pioneers spotify
#moving dotfiles
sudo mv -f $sdr/backend/dotfiles/.bashrc ~
sudo mv -f $sdr/backend/dotfiles/.nanorc ~
sudo mv -f $sdr/backend/dotfiles/grub /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
#enabling services
sudo systemctl enable lightdm
sudo systemctl enable bluetooth
#end of the script
echo The script has finished configuring your system
echo After the script exits you may reboot your computer or continue in chroot
read -p "Press ENTER to end the script"