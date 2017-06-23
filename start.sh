#!/bin/bash

# setup the X400
echo "Configuring the X400..."
printf "snd_soc_bcm2708\nsnd_soc_bcm2708_i2s\nbcm2708_dmaengine\nsnd_soc_pcm512x\nsnd_soc_iqaudio_dac"  >> /etc/modules

# re-start gpsd service to pickup new config
echo "Restarting GPSD..."
/etc/init.d/gpsd restart

# Add btspeaker user if it does not exist already
# echo
# echo "Adding btspeaker user..."
# id -u btspeaker &>/dev/null || useradd btspeaker -G audio
# echo "done."

# Download bt-speaker to /opt (or update if already present)
# echo
# cd /opt
# if [ -d bt-speaker ]; then
#   echo "Updating bt-speaker..."
#   cd bt-speaker && git pull
# else
#   echo "Downloading bt-speaker..."
#   git clone https://github.com/lukasjapan/bt-speaker.git
# fi
# echo "done."

# Install and start bt-speaker daemon
# echo
# echo "Registering and starting bt-speaker with systemd..."
# systemctl enable /opt/bt-speaker/bt_speaker.service
# if [ "`systemctl is-active bt_speaker`" != "active" ]; then
#   systemctl start bt_speaker
# else
#   systemctl restart bt_speaker
# fi
# systemctl status bt_speaker
# echo "done."

# Finished
# echo
# echo "BT-Speaker has been installed."

# Download and configure Shairport-Sync
echo "Downloading Shairport-Sync..."
cd /opt
git clone https://github.com/mikebrady/shairport-sync.git
cd shairport-sync
autoreconf -i -f
./configure --with-alsa --with-avahi --with-ssl=openssl --with-metadata --with-systemd --with-soxr --sysconfdir=/etc
make
getent group shairport-sync &>/dev/null || groupadd -r shairport-sync >/dev/null
getent passwd shairport-sync &> /dev/null || useradd -r -M -g shairport-sync -s /usr/bin/nologin -G audio shairport-sync >/dev/null
sudo make install

# Start shairport-sync
echo "Starting the Shairport-Sync service..."
systemctl enable shairport-sync
if [ "`systemctl is-active shairport-sync`" != "active" ]; then
  systemctl start shairport-sync
else
  systemctl restart shairport-sync
fi
systemctl status shairport-sync
echo "done."

# Configure mopidy with secret spotify details
echo "Configuring Mopidy with Spotify credentials..."
printf "\n[spotify]\nusername = $SPOTIFY_USERNAME\npassword = $SPOTIFY_PASSWORD\nclient_id = $SPOTIFY_CLIENT_ID\nclient_secret = $SPOTIFY_CLIENT_SECRET"  >> /etc/mopidy/mopidy.conf

# Installing Mopidy extensions
echo "Installing Mopidy extensions..."
pip install Mopidy-Local-SQLite
pip install Mopidy-Iris

# Start mopidy
echo "Starting the Mopidy service..."
mkdir /root/media && chown mopidy /root/media
systemctl enable mopidy
if [ "`systemctl is-active mopidy`" != "active" ]; then
  systemctl start mopidy
else
  systemctl restart mopidy
fi
systemctl status mopidy
echo "done."

# Start the Nugget UI
echo "Starting the Nugget UI..."
cd /usr/src/app
npm start

# We're done, let's celebrate
echo "Done, let's make this Nugget sing!"
