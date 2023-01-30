#!/usr/bin/env bash

#stop asking me if i want to fucking save the damn key
rm -rf ~/.ssh/known_hosts

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" > /dev/null 2>&1
    echo ''
fi

# Check for sshpass, install if we don't have it
if test ! $(which sshpass); then
    echo "Installing sshpass..."
    brew install esolitos/ipa/sshpass > /dev/null 2>&1
    echo ''
fi

# Check for iproxy, install if we don't have it
if test ! $(which iproxy); then
    echo "Installing iproxy..."
    brew install libimobiledevice > /dev/null 2>&1
    echo ''
fi

osascript -e 'display notification "Sending reboot..." with title "SliverDuck"'


#change script activated working directory to current directory
cd "$(dirname "$0")"

#echo 'Deleting rm -rf ./PULLEDSystemVersion.plist...'
#rm -rf ./PULLEDSystemVersion.plist

echo 'Starting iproxy...'

# Run iproxy in the background
iproxy 2222:22 > /dev/null 2>&1 &

sleep 2

while true ; do
  result=$(ssh -p 2222 -o BatchMode=yes -o ConnectTimeout=1 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@localhost echo ok 2>&1 | grep Connection)

  if [ -z "$result" ] ; then

echo "Rebooting device..."
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no -p 2222 "root@localhost" 'reboot_bak'
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no -p 2222 "root@localhost" 'reboot'
echo "Device rebooting!"

#ideviceactivation state

# Kill iproxy
kill %1 > /dev/null 2>&1
osascript -e 'display notification "SSH Reboot Command Sent!" with title "SliverDuck"'
echo 'Reboot command sent!'

sleep 1

    break

  fi

osascript -e 'display alert "Connection failed..." message "Device not detected in ramdisk SSH mode...\n\nIf you see nothing on your iPad, please make sure you PWNED the device correctly in checkm8-a5.ino!\n\niPad 2,4? Set checkm8-a5.ino file to:\n#define A5_8942\n\niPad 2,1 - iPad 2,2 - iPad 2,3? Set checkm8-a5.ino file to:\n#define A5_8940"'
  break

  sleep 1
echo ''
echo ''
done

