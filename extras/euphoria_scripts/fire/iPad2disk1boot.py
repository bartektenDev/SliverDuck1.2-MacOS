


import os,time
#standard ramdisk (iphone 4 cdma?)
#os.system("echo 'Sending iphone4cdma disk commands...'");
#os.system("printf '%b\n' '/send newipwndfu/iphone4cdma/devicetree\ndevicetree\n/send newipwndfu/iphone4cdma/ramdisk\nramdisk\n/send newipwndfu/iphone4cdma/kernelcache\nbootx\n/exit' | ./irecovery2 -s");
#print("Loading disk...")

#standard ramdisk
#os.system("echo 'Sending stanrdard disk commands...'");
#os.system("printf '%b\n' '/send newipwndfu/ipad2/devicetree\ndevicetree\n/send newipwndfu/ipad2/ramdisk\nramdisk\n/send newipwndfu/ipad2/kernelcache\nbootx\n/exit' | ./irecovery2 -s");
#print("Loading disk...")

os.system("echo 'Sending standard disk commands...'");
os.system("printf '%b\n' '/send newipwndfu/ipad2/devicetree\ndevicetree\n/send newipwndfu/ipad2/ramdisk\nramdisk\n/send newipwndfu/ipad2/kernelcache\nbootx\n/exit' | ./irecovery2 -s");
print("Loading disk...")


#os.system("printf '%b\n' '/send iphone4cdma/devicetree\ndevicetree\n/send iphone4cdma/ramdisk\nramdisk\n/send iphone4cdma/kernelcache\nbootx\n/exit' | ./irecovery2 -s ");
#print("Loading iphone4cdma disk...")

#OG Disk
#os.system("printf '%b\n' '/send loader/devicetree\ndevicetree\n/send loader/ramdisk\nramdisk\n/send loader/kernelcache\nbootx\n/exit' | ./irecovery2 -s");
