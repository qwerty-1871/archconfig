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
echo "Please enter your password (this may be skipped if you have used 'sudo' recently)"
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
    sudo pacman -Sy --noconfirm virtualbox-host-modules-arch
    else
    sudo pacman -Sy --noconfirm virtualbox-host-dkms
fi
#pacman, first replacing pacman.conf
sudo mv -f $sdr/backend/dotfiles/pacman.conf /etc/pacman.conf
sudo pacman -Sy --noconfirm go nano devtools dkms xorg-server cinnamon lightdm lightdm-slick-greeter os-prober xed brasero rhythmbox libgpod gst-libav kpat xreader kmahjongg gnome-mines neofetch steam openssh bluez bluez-utils firefox-developer-edition virtualbox gnome-screenshot libreoffice-fresh gimp lutris libnotify speech-dispatcher hunspell-en_US networkmanager hexchat discord
#installing yay
cd ~
git clone https://aur.archlinux.org/yay.git
cd yay
yes | makepkg -sri
rm -rf yay
#using yay to install other AUR packages
curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | gpg --import -
yes | yay -S --answerclean None --answerdiff None --answeredit None --answerupgrade None pamac-nosnap xplayer-plparser-git xplayer mintstick pioneers spotify
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
echo Thank you for using Archconfig. Please share any issues you had with the script on the Github. Feedback can be emailed to qwerty1871@gmail.com
echo Enter 'reboot' if you would like the script to reboot your system or 'exit' if you would like the script to exit without reboot
while [ $doned != 'done' ]; do
    read done
    case $done in
    reboot)
    reboot now ;;
    exit)
    exit ;;
    *)
    echo Invalid input
    esac
done