


import os

#old
#load ramdisk
os.system("printf '%b\n' '/send testloader/devicetree\ndevicetree\n/send testloader/ramdisk\nramdisk\n/send testloader/kernelcache\nbootx\n/exit' | ./irecovery2 -s");

#load ramdisk
#os.system("printf '%b\n' '/send newipwndfu/ipad2/devicetree\ndevicetree\n/send newipwndfu/ipad2/ramdisk\nramdisk\n/send newipwndfu/ipad2/kernelcache\nbootx\n/exit' | ./irecovery -s");
print("Loading disk...")

