> Note: This repository is provided as-is for those who find it useful. However, for my personal use case, I have moved on to my newer, desktop-agnostic [all-ways-egpu](https://github.com/ewagner12/all-ways-egpu) script (Yes, it works with Sway too!). Thus, this project may not get updated to address future changes in wlroots such as [this](https://github.com/swaywm/wlroots/pull/2752).

# sway-eGPU-setup
Manages setting of the WLR_DRM_DEVICES environment variable based on cards found by udevadm.

## Installation
I finally added a Makefile! To install the most recent version, just download the repo and from the downloaded directory:

```
sudo make install
```

Configuration and enabling the service to start on bootup has also been automated. After installing, just run:

```
sudo sway_setup.sh setup
```

This stores the BusIDs in the file */usr/share/sway-eGPU-setup/user-pci-ids* by default in the format:
`aa:aa.a,bb:bb.b`
where "aa:aa.a" is the eGPU's BusID in hex and "bb:bb.b" is the (optional) iGPU BusID in hex.
Manual configuration could be done by simply adding this file by hand if you prefer.

Uninstallation is simply:
```
sudo make uninstall
```
from the repo directory.
