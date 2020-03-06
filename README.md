# rasperryoneduroam
A script to configure a raspberry pi 4 running buster to use eduroam.

You can load the code from this directory onto a USB drive and plug it into your raspberry pi. Mount the drive as follows

```bash
  mkdir -p /usb
  mount /dev/sda1 /usb
```
Next, edit the `wpa_supplicant.conf` and `setup.sh` files, replacing the sequence #### with whatever is appropriate. Finally, run the setup.sh file.

```bash
   cd /usb
   bash ./setup.sh
```

This will configure the timezone to CST, the keyboard to standard US, set the locale to en_US.UTF-8, and set the wireless. You will, however, need to reboot after running this step. Enjoy!
