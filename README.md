# sway-eGPU-setup
Manages setting of the WLR_DRM_DEVICES environment variable based on cards found by udevadm.

<b>Be sure to edit sway_setup.sh to change the eGPU and iGPU bus ID's to your own (as reported by lspci)</b>

From the downloaded location, make sure it's executable by doing:

```chmod +x sway_setup.sh```

Move things into place and enable the service to start on bootup:

```
sudo cp sway_setup.sh /usr/bin/

sudo cp sway-start.service /etc/systemd/system

systemctl enable sway-start
```
