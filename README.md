# Archconfig

## Introduction 
Archconfig is a bash script that allows a user to configure and customize Arch Linux following an installation using Archinstall. Archinstall is a wonderful tool however it is deficient in terms of achieving configuration beyond that of a base system. Archconfig will build off of what Archinstall provides in order to give the user a complete system.

Archconfig is currently incomplete and not recommended for regular usage. I would greatly appreciate any feedback or error reports. Feel free to contact me at bqwerty1871@gmail.com.

## Brief installation guide
This is intended for users with a good understanding of Arch Linux. If you need more help see the detailed guide below this one.
First, boot up the latest Arch iso on the computer you wish to install to. Then connect to the internet and run Archinstall with the following settings set:
- A user account with superuser privileges enabled
- No profiles set
- Git included in the additional packages list
- No audio packages
- ISO network configuration copied to install
The rest of the options may be configured at your discretion.
After Archinstall is finished, reboot the system. Log in to your user account and run the following commands to clone and execute the script:
```
git clone https://github.com/qwerty-1871/archconfig
cd archconfig
sudo chmod +x archconfig.sh
./archconfig.sh
```
The script will guide you from that point on. 
## Detailed installation guide
First, download the latest Arch Linux iso from https://archlinux.org/download/. Then burn the iso to a USB drive or other bootable medium. If you are on Linux I recommend using [Mintstick](https://github.com/linuxmint/mintstick) and if you are on Windows I recommend [Rufus](https://rufus.ie/).  
Next boot your computer from the medium you chose. The method of doing this will vary greatly depending on your system. Unless you have a reason to do otherwise, choose the first option in the GRUB menu.  
If you are using ethernet you may skip this step as networking will be set up automatically. Otherwise, run the command iwctl. Run the command `device list` to find the name of your wireless device - hereafter referred to as ‘device’. Then run `station device scan` to initiate a scan for wireless networks. Next run `station device get-networks` to list the known networks. Finally run `station device connect NameOfNetwork` to connect to your network.  
Now you can execute the command `archinstall`. Set the options as follows(my recommendations are not mandatory to use the script, if I speak authoritatively they are):  
Language, Keyboard layout, Mirror region, and Locale - Whichever option corresponds to your spoken language, keyboard, and location.  
Locale encoding - Use the default(UTF-8) unless you have reason to do otherwise  
Drives - I recommend automatic partition with a separate home partition.  
Bootloader - I recommend GRUB  
Swap - I recommend true  
Hostname - Whatever you want it to be  
Root password - I recommend enabling it  
User account - You must create a user with superuser privileges  
Profile - Set this to none  
Audio - None  
Kernels - I recommend using the default  
Additional packages - Nothing but ‘git’  
Network configuration - Copy the ISO configuration to install  
Timezone - I recommend keeping the default UTC  
Automatic time sync - I recommend keeping this enabled  
Optional repositories - None  
Now enter the install button and let Archinstall run.  
Once it is done do not choose to enter chroot; reboot your system.  
Once Arch has booted log in with your superuser account.   
Run the following commands to download the script, change into its directory, allow it to be executed, and run the script. You will need to enter your password for the 3rd of these.   
```
git clone https://github.com/qwerty-1871/archconfig
cd archconfig
sudo chmod +x archconfig.sh
./archconfig.sh 
```
The script should sufficiently guide you from there.
