#!/bin/bash

#change script activated working directory to current directory
cd "$(dirname "$0")"

osascript -e 'display notification "Running exploit..." with title "SliverDuck"'
sleep 1
echo 'Executing iPad 2 ramdisk exploit...'

echo ""
echo "SSH Ramdisk loader for iOS 6.1.3 iPad 2's"
echo "Developed by @ios_euphoria"
echo ""
sleep 1

echo "Uploading standard ramdisk 1..."
sleep 1

#cd newipwndfu
dir=$PWD
##never changes, iBSS exploit all devices
#cd /$dir/newipwndfu && ./ipwndfu -l iBSS24
#sleep 3
#echo "iBSS Loaded!"
#python2 ./ipwndfu -l ipad2ibss.pwn
#works
cd $dir/newipwndfu && python2 ./ipwndfu -l ipad2ibss.pwn
echo "iBSS Loaded!"
sleep 3
#works
cd $dir/newipwndfu && ./irecovery2 -f ipad2/ibec.img3
echo "iBEC Loaded!"
#
osascript -e 'tell app "System Events" to display dialog "Please disconnect and reconnect device!"'
##working up to here
#
##sleep 3
###never changes
#cd ..
#echo $dir
sleep 3
cd $dir/ && python3 iPad2disk1boot.py
#
#sleep 5
#cd $dir/newipwndfu && ./irecovery -f ipad2/ibec.img3
#cd $dir/newipwndfu && python2 ./ipwndfu -l ipad2ibss.pwn
echo "Ramdisk DONE!"

#sleep 5
osascript -e 'display alert "Device booting!" message "Your iPad should now be booting the ramdisk by AppleTech752. If its not, read the terminal for any errors."'
exit 0
