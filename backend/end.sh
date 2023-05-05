#!/bin/bash

echo "The script has finished configuring your system
Thank you for using Archconfig. Please share any issues you had with the script on the Github. Feedback can be emailed to qwerty1871@gmail.com
Enter 'reboot' if you would like the script to reboot your system or 'exit' if you would like the script to exit without reboot"
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
exit