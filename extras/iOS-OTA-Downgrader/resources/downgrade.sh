#!/bin/bash

FRBaseband() {
    local BasebandSHA1L
    
    if [[ $DeviceProc == 7 || $1 == "latest" ]]; then
        mkdir -p saved/baseband 2>/dev/null
        cp -f $IPSWRestore/Firmware/$Baseband saved/baseband/
    fi

    if [[ ! -e saved/baseband/$Baseband ]]; then
        Log "Downloading baseband..."
        $partialzip $BasebandURL Firmware/$Baseband $Baseband
        $partialzip $BasebandURL BuildManifest.plist BuildManifest.plist
        mkdir -p saved/$ProductType saved/baseband 2>/dev/null
        mv $Baseband saved/baseband/
        mv BuildManifest.plist saved/$ProductType/
        BuildManifest="saved/$ProductType/BuildManifest.plist"
    elif [[ $DeviceProc != 7 ]]; then
        BuildManifest="saved/$ProductType/BuildManifest.plist"
    fi

    BasebandSHA1L=$($sha1sum saved/baseband/$Baseband | awk '{print $1}')
    if [[ ! -e $(ls saved/baseband/$Baseband) || $BasebandSHA1L != $BasebandSHA1 ]]; then
        rm -f saved/baseband/$Baseband $BuildManifest
        if [[ $DeviceProc == 7 || $platform == "win" ]]; then
            Error "Downloading/verifying baseband failed. Please run the script again"
        else
            Log "Downloading/verifying baseband failed. Proceeding with --latest-baseband flag"
        fi
    fi
}

FutureRestore() {
    local ExtraArgs=()

    Log "Proceeding to futurerestore..."
    if [[ $IPSWA7 != 1 ]]; then
        ExtraArgs+=("--use-pwndfu")
        cd resources
        $SimpleHTTPServer &
        ServerPID=$!
        cd ..
    fi

    if [[ $DeviceProc == 7 ]]; then
        ExtraArgs+=("-s" "$IPSWRestore/Firmware/all_flash/$SEP" "-m" "$BuildManifest")
        if [[ $IPSWA7 != 1 ]]; then
            # Send dummy file for device detection
            $irecovery -f README.md
            sleep 2
        fi
    elif [[ $SendiBSS != 1 ]]; then
        ExtraArgs+=("--no-ibss")
    fi

    if [[ $Baseband == 0 ]]; then
        Log "Device $ProductType has no baseband/disabled baseband update"
        ExtraArgs+=("--no-baseband")
    else
        FRBaseband $1
        if [[ -e saved/baseband/$Baseband && -e $BuildManifest ]]; then
            ExtraArgs+=("-b" "saved/baseband/$Baseband" "-p" "$BuildManifest")
        else
            rm -f saved/baseband/$Baseband $BuildManifest
            ExtraArgs+=("--latest-baseband")
        fi
    fi

    Log "Running futurerestore with command: $futurerestore -t \"$SHSH\" ${ExtraArgs[*]} \"$IPSWRestore.ipsw\""
    $futurerestore -t "$SHSH" "${ExtraArgs[@]}" "$IPSWRestore.ipsw"
    echo
    Log "Restoring done! "
}

DowngradeOther() {
    local FWKeys
    local NoMove

    Input "Select your IPSW file in the file selection window."
    IPSW="$($zenity --file-selection --file-filter='IPSW | *.ipsw' --title="Select IPSW file")"
    [[ ! -s "$IPSW" ]] && read -p "$(Input 'Enter path to IPSW file:')" IPSW
    [[ ! -s "$IPSW" ]] && Error "No IPSW selected, or IPSW file not found."
    IPSW="${IPSW%?????}"
    Log "Selected IPSW file: $IPSW.ipsw"
    Input "Select your SHSH file in the file selection window."
    SHSH="$($zenity --file-selection --file-filter='SHSH | *.shsh *.shsh2' --title="Select SHSH file")"
    [[ ! -s "$SHSH" ]] && read -p "$(Input 'Enter path to SHSH file:')" SHSH
    [[ ! -s "$SHSH" ]] && Error "No SHSH selected, or SHSH file not found."
    Log "Selected SHSH file: $SHSH"

    Log "Getting version from IPSW"
    unzip -o -j "$IPSW.ipsw" Restore.plist -d tmp
    if [[ $platform == "macos" ]]; then
        plutil -extract 'ProductVersion' xml1 tmp/Restore.plist -o tmp/OSVer
        OSVer=$(cat tmp/OSVer | sed -ne '/<string>/,/<\/string>/p' | sed -e "s/<string>//" | sed "s/<\/string>//" | sed '2d')
        plutil -extract 'ProductBuildVersion' xml1 tmp/Restore.plist -o tmp/BuildVer
        BuildVer=$(cat tmp/BuildVer | sed -ne '/<string>/,/<\/string>/p' | sed -e "s/<string>//" | sed "s/<\/string>//" | sed '2d')
    else
        OSVer=$(cat tmp/Restore.plist | grep -i ProductVersion -A 1 | grep -oPm1 "(?<=<string>)[^<]+")
        BuildVer=$(cat tmp/Restore.plist | grep -i ProductBuildVersion -A 1 | grep -oPm1 "(?<=<string>)[^<]+")
    fi

    FWKeys="./resources/firmware/$ProductType/$BuildVer"
    Log "Checking firmware keys in $FWKeys"
    if [[ -e $FWKeys/index.html ]]; then
        if [[ $(cat $FWKeys/index.html | grep -c "$BuildVer") != 1 ]]; then
            Log "Existing firmware keys are not valid. Deleting"
            rm $FWKeys/index.html
        fi
    fi

    if [[ ! -e $FWKeys/index.html ]]; then
        Log "Getting firmware keys for $ProductType-$BuildVer"
        mkdir -p $FWKeys 2>/dev/null
        curl -L https://github.com/LukeZGD/iOS-OTA-Downgrader-Keys/raw/master/$ProductType/$BuildVer/index.html -o tmp/index.html
        if [[ $(cat tmp/index.html | grep -c "$BuildVer") != 1 ]]; then
            curl -L https://api.m1sta.xyz/wikiproxy/$ProductType/$BuildVer -o tmp/index.html
            if [[ $(cat tmp/index.html | grep -c "$BuildVer") != 1 ]]; then
                Log "WARNING - Failed to download firmware keys."
                NoMove=1
            fi
        fi
        if [[ $NoMove == 1 ]]; then
            rm $FWKeys/index.html
        elif [[ -s tmp/index.html ]]; then
            mv tmp/index.html $FWKeys/
        fi
    fi

    kDFU
    if [[ $(echo $BuildVer | cut -c 1) == 8 ]]; then
        IPSWSetExtract
        iDeviceRestore latest
    elif [[ $platform == "win" || $LinuxARM == 1 ]]; then
        IPSW32Other
        IPSWSetExtract
        iDeviceRestore
        return
    fi
    IPSWSetExtract
    FutureRestore
}


iDeviceRestore() {
    mkdir shsh
    cp "$SHSH" shsh/${UniqueChipID}-${ProductType}-${OSVer}.shsh 2>/dev/null
    Log "Proceeding to idevicerestore..."
    ExtraArgs="-e -w"
    if [[ $1 == "latest" ]]; then
        ExtraArgs="-e"
    elif [[ $Baseband == 0 ]]; then
        Log "Device $ProductType has no baseband/disabled baseband update"
    elif [[ $platform == "win" || $LinuxARM == 1 ]] && [[ $ProductType != "iPhone3"* ]]; then
        ExtraArgs="-r"
        idevicerestore="$idevicererestore"
        re="re"
        FRBaseband
        cp saved/baseband/$Baseband tmp/bbfw.tmp
        cp $BuildManifest tmp/
    fi
    Log "Running idevicere${re}store with command: $idevicerestore $ExtraArgs \"$IPSWRestore.ipsw\""
    $idevicerestore $ExtraArgs "$IPSWRestore.ipsw"
    echo
    Log "Restoring done! Read the message below if any error has occurred:"
    if [[ $platform == "win" ]]; then
        Echo "* Windows users may encounter errors like \"Unable to send APTicket\" or \"Unable to send iBEC\" in the restore process."
        Echo "* Follow the troubleshoting link for steps to attempt fixing this issue."
        Echo "* Troubleshooting link: https://github.com/LukeZGD/iOS-OTA-Downgrader/wiki/Troubleshooting#windows"
    fi
    Echo "* Please read the \"Troubleshooting\" wiki page in GitHub before opening any issue!"
    Echo "* Your problem may have already been addressed within the wiki page."
    Echo "* If opening an issue in GitHub, please provide a FULL log/output. Otherwise, your issue may be dismissed."
    echo
}

IPSWCustomA7() {
    local fr194=()
    if [[ $platform == "macos" ]]; then
        fr194=("https://github.com/futurerestore/futurerestore/releases/download/194/futurerestore-v194-macOS.tar.xz" "d279423dd9a12d3a7eceaeb7e01beb332c306aaa")
    elif [[ $platform == "linux" ]]; then
        fr194=("https://github.com/futurerestore/futurerestore/releases/download/194/futurerestore-v194-ubuntu_20.04.2.tar.xz" "9f2b4b6cc6710d1d68880711001d2dc5b4cb9407")
    fi
    Input "Custom IPSW Option"
    Echo "* When this option is enabled, a custom IPSW will be created/used for restoring."
    Echo "* Only enable this when you encounter problems with futurerestore."
    Echo "* This option is disabled by default (N)."
    read -p "$(Input 'Enable this option? (y/N):')" IPSWA7
    if [[ $IPSWA7 != 'Y' && $IPSWA7 != 'y' ]]; then
        return
    fi
    IPSWA7=1
    Log "Custom IPSW option enabled by user."
    futurerestore="./resources/tools/futurerestore194_$platform"
    if [[ ! -e $futurerestore ]]; then
        cd tmp
        SaveFile ${fr194[0]} futurerestore.tar.xz ${fr194[1]}
        7z x futurerestore.tar.xz
        tar -xf futurerestore*.tar
        chmod +x futurerestore-v194
        mv futurerestore-v194 ../$futurerestore
        cd ..
    fi
 }

RetryOption() {
    Input "Retry Command Option"
    Echo "* This gives users the option to retry the restore command."
    Echo "* It can be useful in case that the restore failed early."
    Echo "* If the restore failed with the device no longer in DFU, this will not work."
    Echo "* This option is disabled by default (N)."
    read -p "$(Input 'Enable this option? (y/N):')" Retry
    if [[ $Retry != 'Y' && $Retry != 'y' ]]; then
        return
    fi
    $1
}

DowngradeOTA() {
    if [[ $DeviceProc != 7 ]]; then
        JailbreakOption
    fi
    SaveOTABlobs
    IPSWFindVerify
    kDFU
    if [[ $Jailbreak == 1 || $ProductType == "$DisableBBUpdate" ]]; then
        IPSW32
    else
        IPSWCustom=0
    fi
    IPSWSetExtract
    FutureRestore
#RetryOption FutureRestore
    osascript -e 'tell app "System Events" to display dialog "Downgrade Complete!"'
}

DowngradeOTAWin() {
    IPSWCustom="${IPSWType}_${OSVer}_${BuildVer}_CustomW"
    if [[ $DeviceProc != 7 ]]; then
        JailbreakOption
        SaveOTABlobs
    fi
    IPSWFindVerify
    if [[ $DeviceProc == 7 ]]; then
        IPSWA7=1
        IPSWSetExtract
        IPSW64
        EnterPwnREC
        local APNonce=$($irecovery -q | grep "NONC" | cut -c 7-)
        Log "APNONCE: $APNonce"
        SaveOTABlobs $APNonce
        IPSWSetExtract set
        FutureRestore
        return
    fi
    kDFU
    IPSW32
    IPSWSetExtract
    iDeviceRestore
    RetryOption iDeviceRestore
}

Downgrade() {
    Log "Select your options when asked. If unsure, go for the defaults (press Enter/Return)."
    echo

    if [[ $DeviceProc == 7 && $platform != "win" ]]; then
        IPSWCustomA7
    fi

    if [[ $OSVer == "Other" ]]; then
        DowngradeOther
        return
    elif [[ $platform == "win" || $LinuxARM == 1 || $IPSWA7 == 1 ]]; then
        DowngradeOTAWin
        return
    fi
    DowngradeOTA
}

Downgrade4() {
    JailbreakOption
    IPSWFindVerify
    Save712Blobs
    if [[ $OSVer == "7.1.2" && $Jailbreak != 1 ]]; then
        IPSWSetExtract
        iDeviceRestore latest
        return
    elif [[ $OSVer != "7.1.2" ]]; then
        IPSWFindVerify 712
    fi
    IPSW4
    IPSWSetExtract
    iDeviceRestore
    RetryOption iDeviceRestore
    Log "Downgrade script done!"
}

RestoreLatest() {
    if [[ $ProductType == "iPhone5"* ]]; then
        IPSWType="iPhone_4.0_32bit"
    elif [[ $DeviceProc == 6 && $ProductType == "iPad3"* ]]; then
        IPSWType="iPad_32bit"
    fi
    IPSWFindVerify
    IPSWSetExtract
    iDeviceRestore latest
}
