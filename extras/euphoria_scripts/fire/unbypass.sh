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

#change script activated working directory to current directory
cd "$(dirname "$0")"



sleep 10

echo 'Starting iproxy...'

# Run iproxy in the background
iproxy 2222:22 > /dev/null 2>&1 &

sleep 2

while true ; do
  result=$(ssh -p 2222 -o BatchMode=yes -o ConnectTimeout=1 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@localhost echo ok 2>&1 | grep Connection)

  if [ -z "$result" ] ; then

echo "Mounting..."
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no -p 2222 "root@localhost" 'mount.sh'
echo "Mounted!"

echo "Restoring Setup.app..."
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no -p 2222 "root@localhost" 'mv /mnt1/Applications/SetupBakk.app/ /mnt1/Applications/Setup.app/'
echo "RESTORED Setup.app!"

echo "Rebooting device..."
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no -p 2222 "root@localhost" 'reboot_bak'
echo "Device rebooting!"

#ideviceactivation state

# Kill iproxy
kill %1 > /dev/null 2>&1
osascript -e 'display notification "Hacktivation Complete!" with title "RequestRacoon 🦝"'
echo 'REMOVED Bypass iCloud iOS 9 Done!'

sleep 1

    break

  fi

  osascript -e 'display alert "Connection failed..." message "Device not detected in ramdisk SSH mode..."'
  break

  sleep 1
echo ''
echo ''
done

