#!/bin/bash

EGPU_PCIE=0a:00.0  #eGPU's bus ID in hex (as reported by lspci)
IGPU_PCIE=00:02.0  #Add internal gpu bus ID if you want internal display on

#Warning: This will overwrite /etc/environment.d/10sway.conf if it already exists
if [[ ! -d /etc/environment.d ]]; then
  mkdir /etc/environment.d
fi

for C_NAME in $(ls /dev/dri/ | grep card); do
  CARD_P=$(udevadm info -n /dev/dri/$C_NAME -q path)
  EGPU_P=$(echo $CARD_P | grep $EGPU_PCIE/drm)
  IGPU_P=$(echo $CARD_P | grep $IGPU_PCIE/drm)
  if [[ -n $EGPU_P ]]; then
    EGPU_VAL=$(echo $EGPU_P | rev | cut -c 1)
  fi
  if [[ -n $IGPU_P ]] && [[ -n $IGPU_PCIE ]]; then
    IGPU_VAL=$(echo $IGPU_P | rev | cut -c 1)
  fi
done

if [[ -n $EGPU_VAL ]]; then
  if [[ -n $IGPU_VAL ]]; then
      echo WLR_DRM_DEVICES=/dev/dri/card$EGPU_VAL:/dev/dri/card$IGPU_VAL > /etc/environment.d/10sway.conf
  else
      echo WLR_DRM_DEVICES=/dev/dri/card$EGPU_VAL > /etc/environment.d/10sway.conf
  fi
else
  if [[ -e /etc/environment.d/10sway.conf ]]; then
    rm /etc/environment.d/10sway.conf
  fi
fi
