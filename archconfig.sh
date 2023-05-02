#!/bin/bash
#variables and other setup
begind='notdone'
uidd='notdone'
kerneld='notdone'
doned='donenot'
graphicsd='notdone'
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
echo "Are you using a version of the kernel other than the default? (y/n)"
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
echo "What type of graphics are you using?"
echo "1) NVIDIA"
echo "2) AMD"
echo "3) Intel"
while [ $graphics != 'done' ]; do
    read graphics
    case $graphics in
    1)
    graphicsd='done' ;;
    2)
    graphicsd='done' ;;
    3) 
    graphicsd='done' ;;
    *)
    echo Invalid input ;;
    esac
done
#creates file to prevent sudo from being asked again
echo "Enter your password to begin installation
From now until the end of the script you will not have to interact with your computer"
sudo touch /etc/sudoers.d/passwd_timeout
sudo bash -c "echo 'Defaults timestamp_timeout=-1' >> /etc/sudoers.d/timestamp_timeout"
#begins installing packages
#install graphics drivers
if [ $graphics = 1 ]; then
    pacman -Sy --noconfirm nvidia nvidia-utils
    elif [ $graphics = 2 ]; then
    pacman -Sy --noconfirm xf86-video-amdgpu mesa 
    else
    pacman -Sy --noconfirm xf86-video-intel mesa
fi
#install vbox drivers
if [ $kernel = n ]; then
    sudo pacman -Sy --noconfirm virtualbox-host-modules-arch
    else
    sudo pacman -Sy --noconfirm virtualbox-host-dkms
fi
#pacman, first replacing pacman.conf
sudo mv -f $sdr/backend/dotfiles/pacman.conf /etc/pacman.conf
sudo pacman -Sy --noconfirm xorg
sudo pacman -Sy --noconfirm go nano devtools dkms cinnamon lightdm lightdm-slick-greeter os-prober xed brasero rhythmbox libgpod gst-libav kpat xreader gnome-terminal kmahjongg gnome-mines neofetch steam openssh bluez bluez-utils firefox-developer-edition virtualbox gnome-screenshot libreoffice-fresh gimp lutris libnotify speech-dispatcher hunspell-en_US networkmanager hexchat discord
#installing yay
cd ~
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg
sudo pacman -U --noconfirm /home/erika/yay/yay-*.pkg.tar.zst
cd ~
rm -rf yay
#using yay to install other AUR packages
curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | gpg --import -
echo -ne '\n' | yay -S --answerclean None --answerdiff None --answeredit None --answerupgrade None pamac-nosnap xplayer-plparser-git xplayer-git mintstick pioneers spotify
#moving dotfiles
sudo mv -f $sdr/backend/dotfiles/.bashrc ~
sudo mv -f $sdr/backend/dotfiles/.nanorc ~
sudo mv -f $sdr/backend/dotfiles/grub /etc/default/grub
sudo mv -f $sdr/backend/dotfiles/lightdm.conf /etc/lightdm/lightdm.conf
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
    sudo rm /etc/sudoers.d/timestamp_timeout
    sudo reboot now ;;
    exit)
    sudo rm /etc/sudoers.d/timestamp_timeout
    exit ;;
    *)
    echo Invalid input
    esac
done
