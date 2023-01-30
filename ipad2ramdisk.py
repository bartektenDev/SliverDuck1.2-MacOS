import re
import tkinter as tk
from tkinter import *
from tkinter import messagebox
import os
import time
#from PIL import ImageTk, Image
from tkinter.simpledialog import askstring
from tkinter.messagebox import showinfo
from subprocess import run
import subprocess
import webbrowser
#from pygame import mixer

# Designed and developed by @ios_euphoria

root = tk.Tk()
frame = tk.Frame(root, width="600", height="300")


frame.pack(fill=BOTH,expand=True)

#tk.Entry(root).pack(fill='x')

root.iconphoto(False, tk.PhotoImage(file='ap752.png'))

def callback(url):
    webbrowser.open_new_tab(url)

#def main():
#    mixer.init()
#    mixer.music.load('./extras/euphoria_scripts/success.mp3')
#    mixer.music.play()
#    root.iconphoto(False, tk.PhotoImage(file='duckhdd.png'))

def closePRGM():
    exit()

def boot1():
    os.system("bash ./extras/iOS-OTA-Downgrader/ramdiskboottest1.sh")
#    os.system("bash ./extras/euphoria_scripts/fire/bootramdisk1iPad2.sh")

def boot2():
    os.system("bash ./extras/iOS-OTA-Downgrader/ramdiskboottest2.sh")
#    os.system("bash ./extras/euphoria_scripts/fire/bootramdisk2iPad2.sh")

def untetheredSSHBypass():
    global LAST_CONNECTED_UDID, LAST_CONNECTED_IOS_VER
    
    print("Loading request script...")
    #root.iconphoto(False, tk.PhotoImage(file='settings.gif'))
    #messagebox.Message("Working...","Working, please wait...")
    os.system("bash ./extras/euphoria_scripts/fire/bypass.sh")

def racoonRebootSSH():
    print("Sending SSH reboot command...")
    os.system("bash ./extras/euphoria_scripts/fire/rebootssh.sh")

root.title('iPad 2 Ramdisk + Untether')
frame.pack()

my_label2 = Label(frame,
                  text = "Once device is ready in DFU, click one of the ramdisks!")
my_label2.place(x=130, y=125)

my_label3 = Label(frame,
                  text = "1 Works Best!")
my_label3.place(x=358, y=150)


#img2 = Image.open("duckhdd.png")
#frame2 = PhotoImage(file=imagefilename, format="gif -index 2")
#NewIMGSize2 = img2.resize((100,100), Image.ANTIALIAS)
#new_image2 = ImageTk.PhotoImage(NewIMGSize2)
#label = Label(frame, image = new_image2)
#label.place(x=248, y=20)

cbeginExploit1 = tk.Button(frame,
                           text="Boot Ramdisk 1",
                           command=boot1,
                           state="normal")
cbeginExploit1.place(x=226, y=145)

cbeginExploit2 = tk.Button(frame,
                           text="Boot Ramdisk 2",
                           command=boot2,
                           state="normal")
cbeginExploit2.place(x=226, y=175)


cbeginExploit4 = tk.Button(frame,
                           text="Run Untethered Bypass",
                           command=untetheredSSHBypass,
                           state="normal")
cbeginExploit4.place(x=202, y=205)

cbeginExploit66 = tk.Button(frame,
                            text="Reboot SSH",
                            command=racoonRebootSSH,
                            state="normal")
cbeginExploit66.place(x=420, y=205)

maintext = Label(root, text="iPad 2 Ramdisk + Untether",font=('Helveticabold', 29))
maintext.place(x=135, y=50)

link = Label(root, text="Follow developer @ios_euphoria",font=('Helveticabold', 12), cursor="hand2")
link.place(x=20, y=235)
link.bind("<Button-1>", lambda e:
          callback("https://twitter.com/ios_euphoria"))

link = Label(root, text="Donate to @ios_euphoria",font=('Helveticabold', 12), cursor="hand2")
link.place(x=420, y=235)
link.bind("<Button-1>", lambda e:
          callback("https://www.buymeacoffee.com/barttarof"))

root.geometry("600x260")

root.resizable(False, False)

root.eval('tk::PlaceWindow . center')

#main()

root.mainloop()
