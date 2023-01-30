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

root.iconphoto(False, tk.PhotoImage(file='down-arrow.png'))

def callback(url):
    webbrowser.open_new_tab(url)

#def main():
#    mixer.init()
#    mixer.music.load('./extras/euphoria_scripts/success.mp3')
#    mixer.music.play()
#    root.iconphoto(False, tk.PhotoImage(file='duckhdd.png'))

def closePRGM():
    exit()

def down8():
    os.system("python3 ./step1_8.py")

def down6():
    os.system("python3 ./step1_6.py")



root.title('Downgrade iPad iOS')
frame.pack()

my_label2 = Label(frame,
                  text = "Select iOS to downgrade to")
my_label2.place(x=215, y=130)


#img2 = Image.open("duckhdd.png")
#frame2 = PhotoImage(file=imagefilename, format="gif -index 2")
#NewIMGSize2 = img2.resize((100,100), Image.ANTIALIAS)
#new_image2 = ImageTk.PhotoImage(NewIMGSize2)
#label = Label(frame, image = new_image2)
#label.place(x=248, y=20)

cbeginExploit1 = tk.Button(frame,
                           text="iOS 8.4.1",
                           command=down8,
                           state="normal")
cbeginExploit1.place(x=260, y=152)

cbeginExploit2 = tk.Button(frame,
                           text="iOS 6.1.3",
                           command=down6,
                           state="normal")
cbeginExploit2.place(x=260, y=180)

maintext = Label(root, text="iPad 2 OTA-Downgrader",font=('Helveticabold', 29))
maintext.place(x=154, y=50)

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
