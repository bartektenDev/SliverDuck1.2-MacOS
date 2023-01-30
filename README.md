
![alt text](https://github.com/bartektenDev/SliverDuck1.2-MacOS/blob/main/Screen%20Shot%202023-01-29%20at%208.04.50%20PM.png)

# SliverDuck by ⚡ @ios_euphoria ⚡
ver 1.1

Tested iOS 6.1.3-8.4.1-9.3.6
#use with caution!!! 

SET UP PROGRAM
1. Open terminal and enter:
cd DRAG_AND_DROP_SLIVERDUCK_FOLDER HERE
2. Then enter in terminal:
sudo chmod 755 ./
3. After that runs, enter in terminal:
sudo xattr -d com.apple.quarantine ./
Hit enter and enter your computer password...
...then move to next step
4. Now drag and drop install_deps.sh into terminal and
hit enter. You may need to read the terminal questions
and enter your password again or press Y/N for some
questions. I recommend for every Y/N questions just
hit N.
5. Once installation is done of the libraries, you can launch
the program like this in terminal:
python3 sduck.py
6. Enjoy!

If you have questions or are stuck you can ask me on twitter and I'll try my best. 
I'm usually flooded with tons of messages but you can give it a shot or check reddit!


TETHERED BYPASS (will lose bypass upon reboot) Eh, if you want to test I guess
1. Connect device in normal mode
2. Click Check Device Info
3. Tap trust on iPad if it asks
4. Click ok on iPad popup window
5. Try again to trust until it reads...
6. Click Free Tethered Bypass!
7. Enjoy! 

UNTETHERED BYPASS (WILL NOT lose bypass upon reboot!) Best Option!
1. Put device into DFU mode
2. Click iPad 2 Ramdisk
3. Select the right ramdisk...
iOS 6-8 iPad 2s choose ramdisk 1 (works best on iOS 6-8)
iOS 8-9 iPad 2s choose ramdisk 2 (works best on iOS 8-9)
4. You will see a popup asking to enter arduino PWN dfu mode.
You want to PWN the ipad now using the arduino. 
First disconnect your iPad from computer and arduino.
Second connect your iPad (normal 30 pin cable to arduino)
Third connect the arduino to computer, if you did this right you will see the light flash 3 times on arduino...
...Wait till you see a solid light on the arduino. 
Once thats done continue to next step...
5. Disconnect iPad from arduino and reconnect the iPad straight to the computer and wait 5 seconds... 
...Click Ok on the popup that is asking you to enter arduino PWN dfu mode...
6. Exploit will now start. Wait till you see popup asking to disconnect and reconnect device. 
Disconnect the ipad and reconnect it to the computer. WAIT 5 seconds. You will see the screen
on the iPad slightly light up! This means its working.
7. Click ok on the disconnect and reconnect device popup.
8. Exploit is finishing. Now you should see the verbose text and then AppleTech752 ssh ramdisk load up.
PLEASE WAIT TILL THE FINAL POPUP SAYING DEVICE IS BOOTING! Click ok on popup.
TO BE SAFE, WAIT about 30 seconds before proceeding...the screen should DIM SLIGHTLY!!!
9. If you feel you're ready, now just press Run Untethered Bypass...
The device will reboot upon completion!!! Enjoy!!

Follow me on twitter @ios_euphoria


HELP? Questions?
The device isn't bypassed?
1. Please wipe the device with iTunes or 3uTools (anti recovery flash option if you can)
2. After the device is wiped the first time and turns on, do not reboot it. Just put into DFU
and try to bypass again. Don't reboot the device after successful wipe, just put into DFU
and run the tool again. It should work. If not, I'm sorry I don't know why its not working for u.


IF YOU GET THIS POPUP IN TERMINAL!!!

[Log] Select your options when asked. If unsure, go for the defaults (press Enter/Return). 

[Input] Jailbreak Option 
* When this option is enabled, your device will be jailbroken on restore. 
* This option is enabled by default (Y). 
[Input] Enable this option? (Y/n): 

JUST CLOSE THE PROGRAM AND RESTART THE ENTIRE PROCESS. 
REBOOT THE IPAD and ENTER DFU AGAIN!!!

IF ANYTHING IS FAILING JUST RESTART THE ENTIRE PROCESS!!! Reboot ipad and close the 
program entirely and restart the steps from the beginning. This may take 1-3 attempts!!

https://www.buymeacoffee.com/barttarof
Donate? 

I'd appreciate any amount really for the time and effort 
put into this project.

Twitter Handle: @ios_euphoria
https://twitter.com/ios_euphoria



SOMETHING NOT WORKING?

Try in the SliverDuck folder:

Command:
sudo xattr -rd com.apple.quarantine ./

Command:
sudo xattr -d com.apple.quarantine ./

Command: 
sudo xattr -r com.apple.quarantine ./

ALSO try to run this Command:
chmod 755 ./

I am not customer service. I made this for myself and released publicly for everyone else to enjoy.
THANKS TO ALL PEOPLE INVOLVED IN MAKING THE OTHER TOOLS TO MAKE THIS GUI POSSIBLE.

⚡ @ios_euphoria ⚡
