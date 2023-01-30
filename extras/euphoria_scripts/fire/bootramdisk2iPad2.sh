#!/bin/bash

#change script activated working directory to current directory
cd "$(dirname "$0")"

osascript -e 'display notification "Running exploit..." with title "SliverDuck"'
sleep 1
echo 'Executing iPad 2 ramdisk exploit...'

echo ""
echo "SSH Ramdisk loader for iOS 8.4.1 - 9.3.6 iPad 2's"
echo "Developed by @ios_euphoria"
echo ""
sleep 1

echo "Uploading alternate ramdisk 2..."
sleep 1


dir=$PWD

#cd newipwndfu
#never changes, iBSS exploit all devices
cd $dir/newipwndfu && python2 ./ipwndfu -l iBSS24
echo "iBSS Loaded!"
sleep 3
cd ..
#changes based on disk standard or alt
#echo
#pwd
#echo
cd $dir/newipwndfu && ./irecovery2 -f testipad2/ibec.img3
echo "iBEC Loaded!"
osascript -e 'tell app "System Events" to display dialog "Please disconnect and reconnect device!"'


#working up to here

sleep 3
#never changes
cd $dir/ && python3 ./iPad2disk2boot.py

echo "Ramdisk DONE!"
osascript -e 'display alert "Device booting!" message "Your iPad should now be booting the ramdisk by AppleTech752. If its not, read the terminal for any errors."'

