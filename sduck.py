import re
import tkinter as tk
from tkinter import *
from tkinter import messagebox
import os
import time


from tkinter.simpledialog import askstring
from tkinter.messagebox import showinfo
from subprocess import run
import subprocess
import webbrowser


# Designed and developed by @ios_euphoria

root = tk.Tk()
frame = tk.Frame(root, width="600", height="300")


frame.pack(fill=BOTH,expand=True)

#tk.Entry(root).pack(fill='x')

root.iconphoto(False, tk.PhotoImage(file='duckhdd.png'))

LAST_CONNECTED_UDID = ""
LAST_CONNECTED_DEVICETYPE = ""
LAST_CONNECTED_IOS_VER = ""
LAST_CONNECTED_DEVICE_ACTIVATION_STATUS = ""

def checkDeviceModel():
    global LAST_CONNECTED_UDID, LAST_CONNECTED_IOS_VER, LAST_CONNECTED_DEVICETYPE, LAST_CONNECTED_DEVICE_ACTIVATION_STATUS
    #step 1 technically
    print("Searching for connected device...")
    #old method
#    os.system("idevicepair unpair")
#    os.system("idevicepair pair")
#    os.system("./extras/euphoria_scripts/ideviceinfo > ./extras/euphoria_scripts/lastdevice.txt")

    os.system("./extras/euphoria_scripts/fire/binaries/Darwin/idevicepair unpair")
    os.system("./extras/euphoria_scripts/fire/binaries/Darwin/idevicepair pair")
    os.system("./extras/euphoria_scripts/fire/binaries/Darwin/ideviceinfo > ./extras/euphoria_scripts/lastdevice.txt")
    time.sleep(1)

    f = open("./extras/euphoria_scripts/lastdevice.txt", "r")
    fileData = f.read()
    f.close()

    if("ERROR:" in fileData):
        #no device was detected, so retry user!
        print("ERROR: No device found!")

        messagebox.showinfo("No device detected! 0x404","Try disconnecting and reconnecting your device.")
    else:
        #we definitely have something connected...

        #find the UDID
        start = 'UniqueDeviceID: '
        end = 'UseRaptorCerts:'
        s = str(fileData)

        foundData = s[s.find(start)+len(start):s.rfind(end)]
        UDID = str(foundData)
        LAST_CONNECTED_UDID = str(UDID)

        #find the iOS
        #we definitely have something connected...
        start2 = 'ProductVersion: '
        end2 = 'ProductionSOC:'
        s2 = str(fileData)

        foundData2 = s2[s.find(start2)+len(start2):s2.rfind(end2)]
        deviceIOS = str(foundData2)
        LAST_CONNECTED_IOS_VER = str(deviceIOS)
        
        ##
#        ProductName: iPhone OS
#        ProductType: iPad2,1
#        ProductVersion: 9.3.5

        start3 = 'ProductType: '
        end3 = 'ProductVersion:'
        s3 = str(fileData)
        
        foundData3 = s3[s.find(start3)+len(start3):s3.rfind(end3)]
        deviceType = str(foundData3)
        LAST_CONNECTED_DEVICETYPE = str(deviceType)
        
#        ActivationState: Unactivated
#BasebandBoardSerialNumber:
        start4 = 'ActivationState: '
        if 'FactoryActivated' in str(fileData):
            LAST_CONNECTED_DEVICE_ACTIVATION_STATUS = "FactoryActivated"
        else:
            LAST_CONNECTED_DEVICE_ACTIVATION_STATUS = "Unactivated"

        if(len(UDID) > 38):
            #stop automatic detection
            timerStatus = 0

            print("Found UDID: "+LAST_CONNECTED_UDID)
            messagebox.showinfo("iDevice is detected!","Found iDevice!\n\nModel Type: "+LAST_CONNECTED_DEVICETYPE+"\niOS: "+LAST_CONNECTED_IOS_VER+"\nActivation State: "+LAST_CONNECTED_DEVICE_ACTIVATION_STATUS)
        
            if("2,1" in LAST_CONNECTED_DEVICETYPE or "2,2" in LAST_CONNECTED_DEVICETYPE or "2,3" in LAST_CONNECTED_DEVICETYPE):
                messagebox.showinfo("iPad 2,1 Found","Great news!\n\nYou can downgrade to iOS 8.4.1 and iOS 6.1.3!")
            else:
                messagebox.showinfo("iPad 2,4 Found","Sad news!\n\nYou can only downgrade to iOS 8.4.1.")
#            cbeginExploit10["state"] = "normal"
#            cbeginExploit2["state"] = "normal"


        else:
            print("Couldn't find your device")
            messagebox.showinfo("Somethings missing! 0x405","Not detected.\n\nTap Trust dialog on device!")

def showDFUMessage():
    messagebox.showinfo("Step 1","Put your iDevice into DFU mode.\n\nClick Ok once its ready in DFU mode to proceed.")

def racoonRequest():
    global LAST_CONNECTED_UDID, LAST_CONNECTED_IOS_VER

    print("Loading request script...")
    #root.iconphoto(False, tk.PhotoImage(file='settings.gif'))
    #messagebox.Message("Working...","Working, please wait...")
    os.system("bash ./extras/euphoria_scripts/fire/rr.sh")

def racoonBypass():
    global LAST_CONNECTED_UDID, LAST_CONNECTED_IOS_VER

    print("Loading request script...")
    #root.iconphoto(False, tk.PhotoImage(file='settings.gif'))
    #messagebox.Message("Working...","Working, please wait...")
    os.system("bash ./extras/euphoria_scripts/fire/bypass.sh")

def racoonUnBypass():
    global LAST_CONNECTED_UDID, LAST_CONNECTED_IOS_VER

    print("Loading request script...")
    #root.iconphoto(False, tk.PhotoImage(file='settings.gif'))
    #messagebox.Message("Working...","Working, please wait...")
    os.system("bash ./extras/euphoria_scripts/fire/unbypass.sh")

def racoonDowngrade():
    global LAST_CONNECTED_UDID, LAST_CONNECTED_IOS_VER

    print("Loading downgrade request script...")
    #root.iconphoto(False, tk.PhotoImage(file='settings.gif'))
    #messagebox.Message("Working...","Working, please wait...")
    os.system("python3 ./downgrade.py")

    
def ipad2ramdisk():
    os.system("python3 ./ipad2ramdisk.py")
    
def startcheckra1n():
    global LAST_CONNECTED_UDID, LAST_CONNECTED_IOS_VER

#    messagebox.showinfo("Connect device in normal mode","Connect your device in normal mode to begin. Then click Ok to move to next step.")
#
    #kick into recovery
#    enterRecMode()
#    time.sleep(6)
    root.iconphoto(False, tk.PhotoImage(file='checkra1nicon.png'))
    messagebox.showinfo("Enter DFU Mode","Get ready...\n\nFirst, press Ok button.\n\nThen, put the device into DFU mode. The jailbreak will automatically complete afterwards.")
    
    print("Loading jb script...")
    os.system("./extras/checkra1n/checkra1n -c -V -E")
    print("Ran jb script.\n")
    #show message to jb
    messagebox.showinfo("Jailbreak Ran","Jailbreak done!\n\nNow Make it Sn0w!")
    root.iconphoto(False, tk.PhotoImage(file='greensn0wicon.png'))

def racoonTicket():
    os.system("ideviceactivation activate -s cengdealajr.gearhostpreview.com/sliver.php -d")
    os.system("bash ./extras/euphoria_scripts/fire/bpdone.sh")

def deactivateDevice():
    os.system("./extras/euphoria_scripts/fire/binaries/Darwin/ideviceactivation deactivate")
    os.system("bash ./extras/euphoria_scripts/fire/bpundo.sh")

def hacktivateDONE_MSG():
    os.system("./extras/euphoria_scripts/doneh.sh")
    
def donateMSG():
    os.system("./extras/euphoria_scripts/donate.sh")

def racoonRebootSSH():
    print("Sending SSH reboot command...")
    os.system("bash ./extras/euphoria_scripts/fire/rebootssh.sh")

def racoonbackboarddSSH():
    print("Sending SSH kill backboardd command...")
    os.system("bash ./extras/euphoria_scripts/fire/backboarddssh.sh")

def enterRecMode():
    print("Kicking device into recovery mode...")
    os.system("./extras/euphoria_scripts/enterrecovery.sh")
    
def exitRecMode():
    print("Kicking device out recovery mode...")
    os.system("./extras/euphoria_scripts/exitrecovery.sh")

def callback(url):
   webbrowser.open_new_tab(url)

def quitProgram():
    print("Exiting...")
    os.system("exit")
    
def opendonate():
    webbrowser.open('https://www.buymeacoffee.com/barttarof', new=2)


root.title('SliverDuck v1.2 - A5 iCloud Bypass iOS 6 - 9.3.6 - @ios_euphoria')
frame.pack()


#img2 = Image.open("racoon.png")
#frame2 = PhotoImage(file=imagefilename, format="gif -index 2")
#NewIMGSize2 = img2.resize((120,120), Image.ANTIALIAS)
#new_image2 = ImageTk.PhotoImage(NewIMGSize2)
#label = Label(frame, image = new_image2)
#label.place(x=235, y=10)

my_label2 = Label(frame,
                 text = "Designed for iPad 2s on iOS 6 - 9.3.6")
my_label2.place(x=180, y=100)


my_label3 = Label(frame,
                 text = "ver 1.2")
my_label3.place(x=10, y=350)

#cbeginExploit2 = tk.Button(frame,
#                   text="Activation Request!",
#                   command=racoonRequest,
#                   state="normal")
#cbeginExploit2.place(x=160, y=160)

cbeginExploit3 = tk.Button(frame,
                           text="iPad 2 Ramdisk",
                           command=ipad2ramdisk,
                           state="normal")
cbeginExploit3.place(x=230, y=160)

cbeginExploit6 = tk.Button(frame,
                           text="iPad 2 Downgrader",
                           command=racoonDowngrade,
                           state="normal")
cbeginExploit6.place(x=218, y=190)

#cbeginExploit4 = tk.Button(frame,
#                 text="Run Untethered Bypass",
#                   command=racoonBypass,
#                   state="normal")
#cbeginExploit4.place(x=320, y=220)

cbeginExploit44 = tk.Button(frame,
                           text="Free Tethered Ticket!",
                           command=racoonTicket,
                           state="normal")
cbeginExploit44.place(x=210, y=220)

#cbeginExploit5 = tk.Button(frame,
#                   text="Revert Bypass",
#                   command=racoonUnBypass,
#                   state="normal")
#cbeginExploit5.place(x=160, y=220)

#cbeginExploit66 = tk.Button(frame,
#                           text="Reboot SSH",
#                           command=racoonRebootSSH,
#                           state="normal")
#cbeginExploit66.place(x=320, y=280)

#cbeginExploit66 = tk.Button(frame,
#                            text="Kill backboardd SSH",
#                            command=racoonbackboarddSSH,
#                            state="normal")
#cbeginExploit66.place(x=320, y=310)

cbeginExploit8 = tk.Button(frame,
                           text="Deactivate Device",
                           command=deactivateDevice,
                           state="normal")
cbeginExploit8.place(x=220, y=270)

cbeginExploit7 = tk.Button(frame,
                           text="Check Device Info",
                           command=checkDeviceModel,
                           state="normal")
cbeginExploit7.place(x=220, y=300)

#cbeginExploit3 = tk.Button(frame,
#                   text="Exit Recovery",
#                   command=exitRecMode,
#                   state="normal")
#cbeginExploit3.place(x=443, y=190)

maintext = Label(root, text="SliverDuck",font=('Helveticabold', 36))
maintext.place(x=215, y=50)

#Create a Label to display the link
link = Label(root, text="Made this tool @ios_euphoria",font=('Helveticabold', 12), cursor="hand2")
link.place(x=210, y=350)
link.bind("<Button-1>", lambda e:
callback("https://twitter.com/ios_euphoria"))

#cbeginExploit2 = tk.Button(frame,
#                   text="Donate to dev!",
#                   command=opendonate,
#                   state="normal")
#cbeginExploit2.place(x=440, y=300)

root.geometry("600x380")

root.resizable(False, False)

root.eval('tk::PlaceWindow . center')

#messagebox.showinfo("Hello!","Please first arduino PWN the iDevice before using any options!")
#song = AudioSegment.from_mp3("./extras/euphoria_scripts/success.mp3")
#messagebox.showinfo("Warning!","Make sure you have wiped the locked iDevice with iTunes using DFU mode before you begin...")

root.mainloop()
