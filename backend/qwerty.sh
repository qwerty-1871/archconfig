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
source $sdr/backend/end.sh
