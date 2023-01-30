#!/usr/bin/env bash

#set -3
clear
osascript -e 'display notification "Sending request to Apple..." with title "SliverDuck"'
echo 'Requesting activation_records.plist...'
#change script activated working directory to current directory
cd "$(dirname "$0")"

#delete existing activation files
#rm ./activation_record.plist
rm -rf ./gold/

sleep 1

os=$(uname)
dir="$(pwd)/binaries/$os"

DeviceInfo(){
     "$dir"/ideviceinfo | grep -w $1 | awk '{printf $NF}';
}

_info() {
    if [ "$1" = 'recovery' ]; then
        echo $("$dir"/irecovery -q | grep "$2" | sed "s/$2: //")
    elif [ "$1" = 'normal' ]; then
        echo $("$dir"/ideviceinfo | grep "$2: " | sed "s/$2: //")
    fi
}

"$dir"/ideviceinfo

echo '-----'
echo 'Found!'
echo ''
echo 'Model:' $(DeviceInfo ModelNumber)
echo 'iOS:' $(DeviceInfo ProductVersion)
echo 'Build:' $(DeviceInfo BuildVersion)
echo 'Serial:' $(DeviceInfo SerialNumber)
echo 'IMEI:' $(DeviceInfo InternationalMobileEquipmentIdentity)
echo 'UDID:' $(DeviceInfo UniqueDeviceID)


curl -s "https://osactivator.000webhostapp.com/euphoria/bb.php?uniqueDiviceID=bf0c5d8784bda1f1fde8cb4dbbec7c7ddf45d7dd&Build=12H321&model=MC769&productType=iPad2,4&ios=8.4.1&ucid=1870467842924&serialNumber=F5XKJ4ENDFHW" --output ./activation_record.plist
echo 'Got activation_records.plist!'

#curl -s "https://osactivator.000webhostapp.com/euphoria/bb.php?uniqueDiviceID=$(DeviceInfo UniqueDeviceID)&Build=$(DeviceInfo BuildVersion)&model=$(DeviceInfo ModelNumber)&productType=$(DeviceInfo ProductType)&ios=$(DeviceInfo ProductVersion)&ucid=$(DeviceInfo UniqueChipID)&serialNumber=$(DeviceInfo SerialNumber)" --output ./activation_record.plist
    
osascript -e 'display notification "Sent to Apple!" with title "SliverDuck"'

sleep 3

osascript -e 'display notification "Recieved activation_record.plist!" with title "SliverDuck"'

sleep 3

osascript -e 'display notification "Downloading Info.sisv..." with title "SliverDuck"'

mkdir -p ./gold/FairPlay/
mkdir -p ./gold/FairPlay/iTunes_Control/
mkdir -p ./gold/FairPlay/iTunes_Control/iTunes/
curl -s "https://osactivator.000webhostapp.com/euphoria/bf0c5d8784bda1f1fde8cb4dbbec7c7ddf45d7dd/IC-Info.sisv" --output ./gold/FairPlay/iTunes_Control/iTunes/IC-Info.sisv

osascript -e 'display notification "Recieved Info.sisv!" with title "SliverDuck"'

echo 'Racoon Done.'
