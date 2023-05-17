#!/bin/bash
#variables and other setup
sudo_nt () {
    #creates file to prevent sudo from being asked again
    echo "Please enter your password now
    This will prevent you from needing to do it again while the script runs
    You may not have to do this if you have used sudo recently"
    sudo touch /etc/sudoers.d/passwd_timeout
    sudo bash -c "echo 'Defaults timestamp_timeout=-1' >> /etc/sudoers.d/timestamp_timeout"
    read -p "The script will now begin installation
    You will not need to interact with your system again until the script has finished
    Press ENTER to continue"
}
begind='notdone'
uidd='notdone'
kerneld='notdone'
doned='donenot'
graphicsd='notdone'
desktopd='notdone'
yayd='notdone'
vboxd='notdone'
xwd='notdone'
blued='notdone'
spotifyd='notdone'
officed='notdone'
libred='notdone'
office='0'
sdr=$PWD
shopt -s lastpipe
#check if script is being run as root; abort if it is
if [ "$EUID" = 0 ]; then 
  echo "This script should not be run as root"
  exit
fi
#start of script, asks for user confirmation before beginning process
echo "Welcome to Archconfig!
If you have not read the .readme file on Github yet, please do so before continuing
Enter 'start' to begin the installation process or 'stop' to abort"
while [ $begind != 'done' ]; do
    read begin
    case $begin in 
    start) 
        begind='done' ;;
    stop) 
        exit ;;
    qwerty)
        begind='done' ;;
    *) echo "Invalid input" ;;
    esac
done
#asks what type of kernel is being used
echo "Are you using a version of the kernel other than the default? (y/n)
Note that this includes linux-lts
If you do not know the answer to this, it is probably no."
while [ $kerneld != 'done' ]; do
    read kernel
    case $kernel in
    y | n) 
    kerneld='done' ;;
    *)
    echo Invalid input ;;
    esac
done
#asks what type of graphics card is being used
echo "What type of graphics are you using?
1) NVIDIA
2) AMD
3) Intel"
while [ $graphicsd != 'done' ]; do
    read graphics
    case $graphics in
    1 | 2 | 3)
    graphicsd='done' ;;
    *)
    echo Invalid input ;;
    esac
done
if [ $begin = qwerty ]; then
    sudo_nt
    source $sdr/backend/qwerty.sh
fi
#asks what desktop the user would like to install, if they choose none asks about installing a display server
echo "What desktop environment would you like to use?
1) GNOME
2) KDE Plasma
4) Xfce
5) None of the above"
while [ $desktopd != 'done' ]; do
    read desktop
    case $desktop in
    1 | 2 | 3 | 4 | 5)
    desktopd='done' ;;
    *)
    echo Invalid input ;;
    esac
done
if [ $desktop = '5' ]; then
    echo "Would you like to install a display server?
    1) Yes, X11
    2) Yes, Wayland
    3) No"
    while [ $xwd != 'done' ]; do
        read xw
        case $xw in
        1 | 2 | 3)
        xwd='done' ;;
        *)
        echo Invalid input ;;
        esac
    done
fi
#asks if the user would like to install an office suite, if they choose libreoffice asks if they want the fresh branch or the still branch
echo "Would you like to install an office suite?
1) Yes, LibreOffice (recommended)
2) Yes, OnlyOffice
3) Yes, FreeOffice
3) No" 
while [ $officed != 'done' ]; do
    read office
    case $office in
    1 | 2 | 3)
    officed='done' ;;
    *)
    echo Invalid input ;;
    esac
done
if [[ $office = '1' ]]; then
    echo "Would you like to install the fresh branch or the still branch?
    The fresh branch recieves more updates but is less stable while the still branch recieves less update but is more stable
    1) Fresh
    2) Still"
    while [ $libred != 'done' ]; do
        read libre
        case $libre in
        1 | 2) 
        libred='done' ;;
        *)
        echo Invalid input ;;
        esac
    done
fi
#questions pertaining to individual packages
echo "You will now be asked a series of questions asking if you would like a specific package that the script has special configurations or support for
Each will expect a simple (y/n) answer. You may also enter h for a brief explanation of the package"
read -p "Press ENTER to continue"
echo Would you like to install support for Bluetooth?
while [ $blued != 'done' ]; do
    read blue
    case $blue in
    y | n)
    blued='done' ;;
    h)
    echo Bluetooth is a short-range networking standard. Saying yes will install the bluez daemon and the blueman GUI ;;
    *)
    echo Invalid input ;;
    esac
done
echo Would you like to install yay?
while [ $yayd != 'done' ]; do
    read yay
    case $yay in
    y | n)
    yayd='done' ;;
    h)
    echo Yay is a pacman wrapper and an AUR helper. Its primary purpose is to allow the user to conveniently and easily install and upgrade packages from the AUR ;;
    *)
    echo Invalid input ;;
    esac
done
echo Would you like to install Virtualbox?
while [ $vboxd != 'done' ]; do
    read vbox
    case $vbox in
    y | n)
    vboxd='done' ;;
    h)
    echo Virtualbox is a virtualizer which allows the user to emulate one or more virtual computers within their machine. ;;
    *)
    echo Invalid input ;;
    esac
done
if [ $yay = 'y' ]; then
    echo Would you like to install Spotify?
    while [ $spotifyd != 'done' ]; do
        read spotify
        case $spotify in
        y | n)
        spotifyd='done' ;;
        h)
        echo Spotify is a properitary music streaming service ;;
        *)
        echo Invalid input ;;
        esac
    done
fi
echo "Are there any other packages you would like to install?
If so, enter their exact names now. Do not use any seperation besides a single space
Precision is important as mistyping the name of a package may break the command
Simply enter nothing here if you do not wish to install anything else at this time"
read packages
sudo_nt
sudo mv -f $sdr/backend/dotfiles/pacman.conf /etc/pacman.conf
pacman -Sy --noconfirm networkmanager devtools dkms go nano
if [ $graphics = 1 ]; then
    sudo pacman -Sy --noconfirm nvidia nvidia-utils
    elif [ $graphics = 2 ]; then
    sudo pacman -Sy --noconfirm xf86-video-amdgpu mesa 
    else
    sudo pacman -Sy --noconfirm xf86-video-intel mesa
fi
if [[ $desktop = '2' || $desktop = '3' || $desktop = '4' || $xw = '1' ]]; then
    sudo pacman -Sy --noconfirm xorg
elif [[ $desktop = '1' || $xw = '2' ]]; then
    sudo pacman -Sy --noconfirm wayland
fi
if [[ $desktop = '2' || $desktop = '3' || $desktop = '4' ]]; then
    sudo pacman -Sy --noconfirm lightdm lightdm-slick-greeter
    sudo systemctl enable lightdm
    sudo mv -f $sdr/backend/dotfiles/lightdm.conf /etc/lightdm/lightdm.conf
fi
if [[ $desktop = '1' ]]; then
    sudo pacman -Sy --noconfirm gnome
    sudo systemctl enable gdm
elif [[ $desktop = '2' ]]; then
    sudo pacman -Sy --noconfirm plasma
elif [[ $desktop = '3' ]]; then
    sudo pacman -Sy --noconfirm cinnamon gnome-panel metacity gnome-screenshot
elif [[ $desktop = '4' ]]; then
    sudo pacman -Sy --noconfirm xfce4
    sudo pacman -Sy --noconfirm xfce4-goodies
fi
if [[ $blue = 'y' ]]; then
    sudo pacman -Sy --noconfirm bluez bluez-utils blueman
    sudo systemctl enable bluetooth
fi
if [[ $yay = 'y' ]]; then
    sudo pacman -Sy --noconfirm go
    cd ~
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg
    sudo pacman -U --noconfirm /home/erika/yay/yay-*.pkg.tar.zst
    cd ~
    rm -rf yay
fi
if [[ $vbox = 'y' ]]; then
    if [ $kernel = n ]; then
        sudo pacman -Sy --noconfirm virtualbox-host-modules-arch
    else
        sudo pacman -Sy --noconfirm virtualbox-host-dkms
    fi
    pacman -Sy --noconfirm virtualbox virtualbox-guest-iso 
    if [[ $yay = 'y' ]]; then
        echo -ne '\n' | yay -S --answerclean None --answerdiff None --answeredit None --answerupgrade None virtualbox-ext-oracle
    fi
fi
if [[ $spotify = 'y' ]]; then 
    echo -ne '\n' | yay -S --answerclean None --answerdiff None --answeredit None --answerupgrade None spotify
fi
if [[ $libre = '1' ]]; then
    sudo pacman -Sy --noconfirm libreoffice-fresh
elif [[ $libre = '2' ]]; then
    sudo pacman -Sy --noconfirm libreoffice-still
elif [[ $office = '2' ]]; then
    sudo pacman -Sy --noconfirm onlyoffice-bin
elif [[ $office = '3' ]]; then
    sudo pacman -Sy --noconfirm freeoffice
fi
source $sdr/backend/end.sh
exit