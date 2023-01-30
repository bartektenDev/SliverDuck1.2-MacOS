#!/bin/bash
trap "Clean" EXIT
trap "Clean; exit 1" INT TERM

cd "$(dirname $0)"
. ./resources/blobs.sh
. ./resources/depends.sh
. ./resources/device.sh
. ./resources/downgrade.sh
. ./resources/ipsw.sh

for i in "$@"; do
    if [[ $i == "EntryDevice" ]]; then
        EntryDevice=1
    elif [[ $i == "NoColor" ]]; then
        NoColor=1
    elif [[ $i == "NoDevice" ]]; then
        NoDevice=1
    elif [[ $i == "NoVersionCheck" ]]; then
        NoVersionCheck=1
    fi
done

if [[ $NoColor != 1 ]]; then
    TERM=xterm-256color
    Color_R=$(tput setaf 9)
    Color_G=$(tput setaf 10)
    Color_B=$(tput setaf 12)
    Color_Y=$(tput setaf 11)
    Color_N=$(tput sgr0)
fi

Clean() {
    rm -rf iP*/ shsh/ tmp/ *.im4p *.bbfw *.plist *.tmp version.xml
    kill $iproxyPID $ServerPID 2>/dev/null
}

Echo() {
    echo "${Color_B}$1 ${Color_N}"
}

Error() {
    echo -e "\n${Color_R}[Error] $1 ${Color_N}"
    [[ -n $2 ]] && echo "${Color_R}* $2 ${Color_N}"
    echo
    ExitWin 1
}

Input() {
    echo "${Color_Y}[Input] $1 ${Color_N}"
}

Log() {
    echo "${Color_G}[Log] $1 ${Color_N}"
}

ExitWin() {
    if [[ $platform == "win" ]]; then
        echo
        Input "Press Enter/Return to exit."
        read -s
    fi
    exit $1
}

Main() {
    local Selection=()

    clear
    Echo "******* iOS-OTA-Downgrader *******"
    Echo " - Downgrader script by LukeZGD - "
    echo
    
    if [[ $EUID == 0 ]]; then
        Error "Running the script as root is not allowed."
    fi

    if [[ ! -d ./resources ]]; then
        Error "resources folder cannot be found. Replace resources folder and try again." \
        "If resources folder is present try removing spaces from path/folder name"
    fi

    SetToolPaths
    if [[ $? != 0 ]]; then
        Error "Setting tool paths failed. Your copy of iOS-OTA-Downgrader seems to be incomplete."
    fi
    
    if [[ ! $platform ]]; then
        Error "Platform is unknown/not supported." "Supported platforms: macOS, Linux, Windows"
    fi

    if [[ -d .git ]]; then
        if [[ $platform == "macos" ]]; then
            CurrentVersion="$(date -r $(git log -1 --format="%at") +%Y-%m-%d)-$(git rev-parse HEAD | cut -c -7)"
        else
            CurrentVersion="$(date -d @$(git log -1 --format="%at") --rfc-3339=date)-$(git rev-parse HEAD | cut -c -7)"
        fi
    elif [[ -e resources/git_hash ]]; then
        CurrentVersion="$(cat resources/git_hash)"
    else
        Log ".git directory and git_hash file not found, cannot determine version."
        if [[ $NoVersionCheck != 1 ]]; then
            Error "Your copy of iOS-OTA-Downgrader is downloaded incorrectly. Do not use the \"Code\" button in GitHub." \
            "Please download iOS-OTA-Downgrader using git clone or from GitHub releases: https://github.com/LukeZGD/iOS-OTA-Downgrader/releases"
        fi
    fi
    [[ -n $CurrentVersion ]] && Echo "* Version: $CurrentVersion"

    chmod +x ./resources/*.sh ./resources/tools/*
    if [[ $? != 0 ]]; then
        Error "A problem with file permissions has been detected, cannot proceed."
    fi
    
    Log "Checking Internet connection..."
    $ping 208.67.222.222 >/dev/null
    if [[ $? != 0 ]]; then
        Error "Please check your Internet connection before proceeding."
    fi
    
    if [[ $(uname -m) != "x86_64" && $(uname -m) == "a"* ]]; then
        if [[ $platform == "macos" ]]; then
            Log "Apple Silicon Mac detected. Support may be limited, proceed at your own risk."
        elif [[ $platform == "linux" ]]; then
            Log "Linux ARM ($(uname -m)) detected. Support may be limited, proceed at your own risk."
            Echo "* Note that only 32-bit (armhf) is compiled natively for now. For 64-bit, get the x86_64 version and box64 might work."
            [[ $(getconf LONG_BIT) != 64 ]] && LinuxARM=1
        elif [[ $platform == "win" ]]; then
            Log "WARNING - Windows ARM is not tested or supported."
            Echo "* You must be using Windows 11 on ARM or newer."
        fi
    elif [[ $(uname -m) != "x86_64" ]]; then
        Error "Platform architecture ($(uname -m)) is not supported." "Supported architectures: x86_64, armhf (Linux), arm64 (macOS only for now)"
    fi

    if [[ $1 == "Install" || -z $bspatch || ! -e $ideviceinfo || ! -e $irecoverychk ||
          ! -e $ideviceenterrecovery || ! -e $iproxy || -z $python ||
          ! -e ./resources/first_run ]]; then
        Clean
        InstallDepends
    fi
    
    GetDeviceValues
    Clean
    mkdir tmp

    if [[ -n $1 && $1 != "No"* && $1 != *"Device" ]]; then
        Mode="$1"
    else
        [[ $NoDevice != 1 ]] && Selection+=("Downgrade Device")
        [[ $DeviceProc != 4 ]] && Selection+=("Save OTA Blobs")

        if [[ $ProductType == "iPhone3"* && $NoDevice != 1 ]]; then
            Selection+=("Restore to 7.1.2")
            [[ $ProductType != "iPhone3,2" ]] && Selection+=("Disable/Enable Exploit")
            [[ $ProductType == "iPhone3,1" ]] && Selection+=("SSH Ramdisk")
        fi

        if [[ $DeviceProc != 7 ]]; then
            Selection+=("Create Custom IPSW")
            [[ $DeviceState == "Normal" ]] && Selection+=("Put Device in kDFU Mode")
            [[ $DeviceProc != 4 ]] && Selection+=("Restore to latest iOS")
        fi

        Selection+=("(Re-)Install Dependencies" "(Any other key to exit)")
        Echo "*** Main Menu ***"
        Input "Select an option:"
        select opt in "${Selection[@]}"; do
        case $opt in
            "Downgrade Device" ) Mode="Downgrade"; break;;
            "Save OTA Blobs" ) Mode="SaveOTABlobs"; break;;
            "Create Custom IPSW" ) Mode="IPSW32"; break;;
            "Put Device in kDFU Mode" ) Mode="kDFU"; break;;
            "Disable/Enable Exploit" ) Mode="Remove4"; break;;
            "Restore to 7.1.2" ) Mode="Restore712"; break;;
            "Restore to latest iOS" ) Mode="RestoreLatest"; break;;
            "SSH Ramdisk" ) Mode="Ramdisk4"; break;;
            "(Re-)Install Dependencies" ) InstallDepends;;
            * ) exit 0;;
        esac

        done
    fi

    SelectVersion

    if [[ $Mode == "IPSW32" ]]; then
        echo
        [[ $platform == "win" ]] && IPSWCustom="${IPSWType}_${OSVer}_${BuildVer}_CustomW"
        JailbreakOption
        if [[ -e "$IPSWCustom.ipsw" ]]; then
            Log "Found existing Custom IPSW, stopping here."
            Echo "* If you want to re-create the custom IPSW, move/delete the existing one first."
            ExitWin 0
        elif [[ $Jailbreak != 1 && $platform != "win" && $LinuxARM != 1 ]]; then
            if [[ $DeviceProc == 4 && $OSVer == "7.1.2" ]]; then
                Log "Creating custom IPSW is not needed for non-jailbroken 7.1.2 restores."
                ExitWin 0
            elif [[ $ProductType != "iPhone3"* && $ProductType != "$DisableBBUpdate" ]]; then
                Log "Creating custom IPSW is not needed for non-jailbroken restores on your device."
                ExitWin 0
            fi
        fi

        IPSWFindVerify
        if [[ $DeviceProc == 4 ]]; then
            [[ $OSVer != "7.1.2" ]] && IPSWFindVerify 712
            IPSW4
        else
            IPSW32
        fi
        Log "Custom IPSW has been created: $IPSWCustom.ipsw"
        [[ $Jailbreak == 1 ]] && Echo "* This custom IPSW has a jailbreak built in ($JBName)"
        Echo "* Run the script again and select Downgrade Device to use the custom IPSW."
        if [[ $DeviceProc != 4 && $platform != "win" && $LinuxARM != 1 ]]; then
            Echo "* You may also use futurerestore manually (make sure to use the latest beta)"
        fi
        ExitWin 0

    elif [[ $Mode != "Downgrade"* && $Mode != *"4" ]]; then
        $Mode
        ExitWin 0
    fi

    if [[ $DeviceProc == 7 && $platform == "win" ]]; then
        local Message="If you want to restore your A7 device on Windows, put the device in pwnDFU mode."
        if [[ $DeviceState == "Normal" ]]; then
            Error "$Message"
        elif [[ $DeviceState == "Recovery" ]]; then
            Log "A7 device detected in recovery mode."
            Log "$Message"
            RecoveryExit
        elif [[ $DeviceState == "DFU" ]]; then
            Log "A7 device detected in DFU mode."
            Echo "* Make sure that your device is already in pwnDFU mode with signature checks disabled."
            Echo "* If your device is not in pwnDFU mode, the restore will not proceed!"
            Echo "* Entering pwnDFU mode is not supported on Windows. You need to use a Mac/Linux machine or another iOS device to do so."
            Input "Press Enter/Return to continue (or press Ctrl+C to cancel)"
            read -s
        fi

    elif [[ $Mode == *"4" || $DeviceProc == 7 ]]; then
        if [[ $DeviceState == "Normal" && $OSVer == "7.1.2" ]]; then
            kDFU
        elif [[ $DeviceState == "DFU" && $OSVer == "7.1.2" ]]; then
            Echo "* Please specify if the device is already in kDFU mode or not."
            read -p "$(Input 'Is your device in kDFU mode? (y/N):')" opt
            if [[ $opt == "Y" || $opt == "y" ]]; then
                Log "kDFU mode specified by user."
            else
                EnterPwnDFU
            fi
        elif [[ $DeviceState == "Normal" ]]; then
            Echo "* The device needs to be in recovery/DFU mode before proceeding."
            read -p "$(Input 'Send device to recovery mode? (y/N):')" Selection
            [[ $Selection == 'Y' || $Selection == 'y' ]] && Recovery || exit
        elif [[ $DeviceState == "Recovery" ]]; then
            Recovery
        elif [[ $DeviceState == "DFU" ]]; then
            EnterPwnDFU
        fi
        if [[ $Mode == *"4" ]]; then
            $Mode
            ExitWin 0
        fi

    elif [[ $DeviceState == "DFU" ]]; then
        Log "32-bit A${DeviceProc} device detected in DFU mode."
        Echo "* DFU Advanced Menu"
        Echo "* Please specify if the device is already in kDFU mode or not."
        Echo "* Troubleshooting link: https://github.com/LukeZGD/iOS-OTA-Downgrader/wiki/Troubleshooting#dfu-advanced-menu-for-32-bit-devices"
        read -p "$(Input 'Is your device in kDFU mode? (y/N):')" opt
        if [[ $opt == "Y" || $opt == "y" ]]; then
            Log "kDFU mode specified by user."
        elif [[ $platform == "win" ]]; then
            echo -e "\n${Color_R}[Error] Your device must be either in normal mode or kDFU mode for Windows. ${Color_N}"
            echo "${Color_Y}* Please put the device in normal mode and jailbroken before proceeding. ${Color_N}"
            echo "${Color_Y}* Exit DFU mode by holding the TOP and HOME buttons for 15 seconds. ${Color_N}"
            ExitWin 1
        elif [[ $DeviceProc == 5 ]]; then
            SendPwnediBSS
        else
            EnterPwnDFU
        fi
        Log "Downgrading $ProductType in kDFU/pwnDFU mode..."
    
    elif [[ $DeviceState == "Recovery" ]]; then
        if [[ $DeviceProc == 4 || $DeviceProc == 6 ]] && [[ $platform != "win" ]]; then
            Recovery
        else
            Log "32-bit A${DeviceProc} device detected in recovery mode."
            Echo "* Please put the device in normal mode and jailbroken before proceeding."
            Echo "* For usage of the DFU Advanced Menu, put the device in kDFU or pwnDFU mode"
            RecoveryExit
        fi
        Log "Downgrading $ProductType in pwnDFU mode..."
    fi
    
    Downgrade
    Log "Downgrade script done!"
    ExitWin 0
}

SelectVersion() {
    if [[ $DeviceProc == 7 ]]; then
        OSVer="10.3.3"
        BuildVer="14G60"
        return
    elif [[ $Mode == "RestoreLatest" ]]; then
        OSVer=$LatestVer
        BuildVer=$LatestBuildVer
        return
    elif [[ $Mode == "kDFU" || $Mode == *"4" ]]; then
        return
    fi
    
    if [[ $ProductType == "iPhone5,3" || $ProductType == "iPhone5,4" || $ProductType == "iPhone3"* ]]; then
        Selection=()
    else
        Selection=("iOS 8.4.1")
    fi
    
    if [[ $ProductType == "iPad2,1" || $ProductType == "iPad2,2" ||
          $ProductType == "iPad2,3" || $ProductType == "iPhone4,1" ]]; then
        Selection+=("iOS 6.1.3")
    fi

    if [[ $ProductType == "iPhone3"* ]]; then
        [[ $Mode == "IPSW32" ]] && Selection+=("7.1.2")
        [[ $ProductType != "iPhone3,2" ]] && Selection+=("6.1.3")

        if [[ $platform == "macos" ]]; then
            Echo "* WARNING - Using iPhone4Down on macOS is not recommended for downgrading."
            Echo "* Please use powdersn0w or cherryflowerJB from dora2ios instead."
        fi

        if [[ $ProductType == "iPhone3,1" ]]; then
            Selection+=("5.1.1 (9B208)" "5.1.1 (9B206)")
            Selection2=("6.1.2" "6.1" "6.0.1" "6.0" "5.1" "5.0.1" "5.0")
            if [[ $platform != "linux" ]]; then
                Echo "* iOS 4.3.x downgrades are supported on Linux only"
                Echo "* For macOS users, use cherryflowerJB instead"
            fi
            if [[ $platform != "win" && $LinuxARM != 1 ]]; then
                Selection+=("4.3.5")
                Selection2+=("4.3.3" "4.3")
            fi
            Selection+=("More versions")

        elif [[ $ProductType == "iPhone3,3" && $platform != "macos" && $Mode != "Restore712" ]]; then
            Echo "* WARNING - iPhone3,3 support is not well tested. Please use powdersn0w from dora2ios instead."
            Echo "* For creating 6.1.3 custom IPSW, make sure to have darling installed: https://github.com/darlinghq/darling"
            Echo "* For Ubuntu/Debian, you may install the .deb from releases."
            Echo "* For Arch, you may install darling-bin from AUR."
            Echo "* For other distros, you might need to build darling yourself."
        fi

        if [[ $Mode == "Restore712" ]]; then
            Echo "* Make sure to disable the exploit first! See the README and wiki for more details."
            Input "Press Enter/Return to continue (or press Ctrl+C to cancel)"
            read -s
            OSVer="7.1.2"
            BuildVer="11D257"
            Mode="Downgrade4"
            return
        fi

        if [[ $Mode == "Downgrade" ]]; then
            Mode="Downgrade4"
        fi
    fi

    if [[ $Mode == "Downgrade"* ]]; then
        Selection+=("Other (use SHSH blobs)")
    fi
    Selection+=("(Any other key to exit)")
    
    echo
    Input "Select iOS version:"
    select opt in "${Selection[@]}"; do
    case $opt in
        "iOS 8.4.1" ) OSVer="8.4.1"; BuildVer="12H321"; break;;
        "iOS 6.1.3" ) OSVer="6.1.3"; BuildVer="10B329"; break;;
        "Other (use SHSH blobs)" ) OSVer="Other"; break;;
        "7.1.2" ) OSVer="7.1.2"; BuildVer="11D257"; break;;
        "6.1.3" ) OSVer="6.1.3"; BuildVer="10B329"; break;;
        "5.1.1 (9B208)" ) OSVer="5.1.1"; BuildVer="9B208"; break;;
        "5.1.1 (9B206)" ) OSVer="5.1.1"; BuildVer="9B206"; break;;
        "4.3.5" ) OSVer="4.3.5"; BuildVer="8L1"; break;;
        "More versions" ) OSVer="More"; break;;
        * ) exit 0;;
    esac
    done

    if [[ $OSVer == "Other" ]]; then
        Mode="Downgrade"
    elif [[ $OSVer == "More" ]]; then
        select opt in "${Selection2[@]}"; do
        case $opt in
            "6.1.2" ) OSVer="6.1.2"; BuildVer="10B146"; break;;
            "6.1" ) OSVer="6.1"; BuildVer="10B144"; break;;
            "6.0.1" ) OSVer="6.0.1"; BuildVer="10A523"; break;;
            "6.0" ) OSVer="6.0"; BuildVer="10A403"; break;;
            "5.1" ) OSVer="5.1"; BuildVer="9B176"; break;;
            "5.0.1" ) OSVer="5.0.1"; BuildVer="9A405"; break;;
            "5.0" ) OSVer="5.0"; BuildVer="9A334"; break;;
            "4.3.3" ) OSVer="4.3.3"; BuildVer="8J2"; break;;
            "4.3" ) OSVer="4.3"; BuildVer="8F190"; break;;
            * ) exit 0;;
        esac
        done
    fi
}

Main $1
