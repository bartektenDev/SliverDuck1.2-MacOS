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

root.iconphoto(False, tk.PhotoImage(file='ios6.png'))

def callback(url):
    webbrowser.open_new_tab(url)

#def main():
#    mixer.init()
#    mixer.music.load('./extras/euphoria_scripts/success.mp3')
#    mixer.music.play()
#    root.iconphoto(False, tk.PhotoImage(file='duckhdd.png'))

def closePRGM():
    exit()

def downExec():
    os.system("bash ./extras/iOS-OTA-Downgrader/restore6.sh")



root.title('iOS 6.1.3 Downgrade')
frame.pack()

my_label2 = Label(frame,
                  text = "Once device is ready in DFU, click Downgrade button.")
my_label2.place(x=130, y=130)


#img2 = Image.open("duckhdd.png")
#frame2 = PhotoImage(file=imagefilename, format="gif -index 2")
#NewIMGSize2 = img2.resize((100,100), Image.ANTIALIAS)
#new_image2 = ImageTk.PhotoImage(NewIMGSize2)
#label = Label(frame, image = new_image2)
#label.place(x=248, y=20)

cbeginExploit1 = tk.Button(frame,
                           text="Begin Downgrade!",
                           command=downExec,
                           state="normal")
cbeginExploit1.place(x=230, y=152)

maintext = Label(root, text="iOS 6.1.3 Downgrade",font=('Helveticabold', 24))
maintext.place(x=195, y=50)


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
