#!/bin/bash

USER_IDS_DIR=/usr/share/sway-eGPU-setup

function setup() {
  if [[ ! -d /etc/environment.d ]]; then
    mkdir /etc/environment.d
  fi

  echo "Warning: This will overwrite /etc/environment.d/10sway.conf if it already exists."
  echo "Which of these cards is your eGPU?"
  lspci -d ::0300 && lspci -d ::0302
  echo "Please type in the eGPU BusID (in hex!), e.g: 0a:00.0"
  read -r EGPU_PCIE
  echo "If you want the internal display on, enter your iGPU BusID now. If not, just press [ENTER]"
  read -r IGPU_PCIE

  if [[ ! -d $USER_IDS_DIR ]]; then
    mkdir $USER_IDS_DIR
  fi
  echo "$EGPU_PCIE","$IGPU_PCIE" > $USER_IDS_DIR/user-pcie-ids

  echo "Enabling automatic start-up service (disable sway-start.service if you don't want this)"
  systemctl enable sway-start
}

# check if the script is run as root
if [[ $EUID -ne 0 ]]; then 
    echo "You need to run the script with root privileges"
    exit
fi

if [[ $1 = "setup" ]]; then
  setup

else
  if [[ ! -e $USER_IDS_DIR/user-pcie-ids ]]; then
    echo "Please run sway_setup.sh setup"
    exit
  fi
  
  EGPU_PCIE=$(cut -d "," -f 1 < $USER_IDS_DIR/user-pcie-ids)
  IGPU_PCIE=$(cut -d "," -f 2 < $USER_IDS_DIR/user-pcie-ids)

  for C_NAME in /dev/dri/card*; do
    CARD_P=$(udevadm info -n "$C_NAME" -q path)
    EGPU_P=$(echo "$CARD_P" | grep "$EGPU_PCIE"/drm)
    IGPU_P=$(echo "$CARD_P" | grep "$IGPU_PCIE"/drm)
    if [[ -n $EGPU_P ]]; then
      EGPU_VAL=$(echo "$EGPU_P" | rev | cut -c 1)
    fi
    if [[ -n $IGPU_P ]] && [[ -n $IGPU_PCIE ]]; then
      IGPU_VAL=$(echo "$IGPU_P" | rev | cut -c 1)
    fi
  done

  if [[ -n $EGPU_VAL ]]; then
    if [[ -n $IGPU_VAL ]]; then
      echo WLR_DRM_DEVICES=/dev/dri/card"$EGPU_VAL":/dev/dri/card"$IGPU_VAL" > /etc/environment.d/10sway.conf
    else
      echo WLR_DRM_DEVICES=/dev/dri/card"$EGPU_VAL" > /etc/environment.d/10sway.conf
    fi
  else
    if [[ -e /etc/environment.d/10sway.conf ]]; then
      rm /etc/environment.d/10sway.conf
    fi
  fi
fi
