


import os
#alternate ramdisk option WORKS all the time
os.system("echo 'Sending alt disk commands...'");
os.system("printf '%b\n' '/send newipwndfu/testipad2/devicetree\ndevicetree\n/send newipwndfu/testipad2/ramdisk\nramdisk\n/send newipwndfu/testipad2/kernelcache\nbootx\n/exit' | ./irecovery2 -s");
print("Loading disk...")




#OG Disk
#os.system("printf '%b\n' '/send loader/devicetree\ndevicetree\n/send loader/ramdisk\nramdisk\n/send loader/kernelcache\nbootx\n/exit' | ./irecovery2 -s");
