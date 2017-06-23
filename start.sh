#!/bin/bash

# setup the X400
printf "snd_soc_bcm2708\nsnd_soc_bcm2708_i2s\nbcm2708_dmaengine\nsnd_soc_pcm512x\nsnd_soc_iqaudio_dac"  >> /etc/modules

# re-start gpsd service to pickup new config
/etc/init.d/gpsd restart

# Add btspeaker user if not exist already
echo
echo "Adding btspeaker user..."
id -u btspeaker &>/dev/null || useradd btspeaker -G audio
echo "done."

# Download bt-speaker to /opt (or update if already present)
echo
cd /opt
if [ -d bt-speaker ]; then
  echo "Updating bt-speaker..."
  cd bt-speaker && git pull
else
  echo "Downloading bt-speaker..."
  git clone https://github.com/lukasjapan/bt-speaker.git
fi
echo "done."

# Install and start bt-speaker daemon
echo
echo "Registering and starting bt-speaker with systemd..."
systemctl enable /opt/bt-speaker/bt_speaker.service
if [ "`systemctl is-active bt_speaker`" != "active" ]; then
  systemctl start bt_speaker
else
  systemctl restart bt_speaker
fi
systemctl status bt_speaker
echo "done."

# Finished
echo
echo "BT-Speaker has been installed."

# Start mopidy
systemctl enable mopidy

# Start the application
cd /usr/src/app
npm start
