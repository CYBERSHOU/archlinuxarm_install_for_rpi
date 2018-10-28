#!/bin/bash
### installing archlinux for raspberrypi

if [ "$1" == "-h" ];
then
    echo "Usage: $0 /dev/<sdx> <path>/<file_image.tar.gz>"
    echo "In <sdx> enter the device you wish to install on."
    echo "For <file_image> go to http://os.archlinuxarm.org/os/ and choose the latest."
    echo "And download it. You may try other distributions images but with no"
    echo "warranty it will work."
    echo "Or just enter the /dev/sdx and by default the file"
    echo "is http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-latest.tar.gz"
    echo "You can also type $0 -h for help."
    exit
fi

if [ -z "$1" ];
then
    echo "Usage: $0 /dev/<sdx> <path>/<file_image.tar.gz>"
    echo "In <sdx> enter the device you wish to install on."
    echo "For <file_image> go to http://os.archlinuxarm.org/os/ and choose the latest."
    echo "And download it. You may try other distributions images but with no"
    echo "warranty it will work."
    echo "Or just enter the /dev/sdx and by default the file"
    echo "is http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-latest.tar.gz"
    echo "You can also type $0 -h for help."
    exit
fi


cd /mnt
URL=""
IMAGE=$2
if [ -z $2 ];
then
    IMAGE="ArchLinuxARM-rpi-latest.tar.gz"
    URL="http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-latest.tar.gz"
    sudo wget $URL
fi

sudo umount $1p1
sudo umount $1p2
echo "Type o (clear partitions)."
echo "Type n, p, 1, ENTER, type +100M."
echo "Type t, then c (FAT32)."
echo "Type n, p, 2, ENTER twice."
echo "Typa a, 1, (bootable p1)"
echo "Type w to write and exit."
sudo fdisk $1
sudo mkfs.vfat $1p1
sudo mkdir boot
sudo mount $1p1 boot
sudo mkfs.ext4 $1p2
sudo mkdir root
sudo mount $1p2 root
cd root/
su -c "bsdtar -xvpf $IMAGE"
cd ..
su -c 'sync'
sudo mv root/boot/* boot
sudo umount boot root
sudo rm -rf boot root
if [ ! -z $URL ];
then 
    sudo rm $IMAGE
fi
echo "Password for alarm is alarm"
echo "Password for root is root"
echo "After boot type the following commands:"
echo "pacman-key --init"
echo "pacman-key populate archlinuxarm"

#//EOF
