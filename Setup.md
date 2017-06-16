# Setup Instructions

## Pre-Requisites

- Download the latest raspbian lite from https://www.raspberrypi.org/downloads/raspbian/
- Login with defaults then configure using `sudo raspi-config` (change hostname, password, set default audio output to headphone jack, enable SSH)
- Setup Wifi in /etc/wpa_supplicant/wpa_supplicant.conf, add the following lines:

```
network={
  ssid="YOUR_SSID"
  psk="YOUR_PASSWORD"
}
```

- Update software to latest with `sudo apt-get update && sudo apt-get upgrade`
- Install screen to allow switching computers `sudo apt-get install screen`
- Setup bluetooth speaker using https://github.com/lukasjapan/bt-speaker
- Install nginx `sudo apt-get install nginx`
- Start nginx `sudo /etc/init.d/nginx start`
- Enable nginx to start at boot `sudo update-rc.d -f nginx defaults`
- Add the nodejs repo `curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -`
- Install nodejs `sudo apt-get install -y nodejs`
- Edit config file /etc/modules and add line `snd_bcm2835`
- Install mplayer `sudo apt-get install mplayer`
- Edit config file /etc/mplayer/mplayer.conf and add line `nolirc=yes`
- Install festival for Text To Speech `sudo apt-get install festival`

# Setting up the GPS
- Install drivers `sudo apt-get install gpsd gpsd-clients`
- Identify the GPS with `ls /dev/ttyUSB*`
- Configure the GPS config as follows `sudo nano /etc/default/gpsd`

```
START_DAEMON="true"
GPSD_OPTIONS="n"
DEVICES="/dev/ttyUSB0"
USBAUTO="false"
GPSD_SOCET="/var/run/gpsd.sock"
```

- Run `sudo /etc/init.d/gpsd restart`
- Test GPS is working with `cgps -s `

# Setting up the camera
- Run `sudo raspi-config` and enable the camera
- Instal AV tools `sudo apt-get install libav-tools`
- Install VLC `sudo apt-get install vlc`
- Setup a local VLC stream `raspivid -o - -t 0 -n | cvlc -vvv stream:///dev/stdin --sout '#rtp{sdp=rtsp://:8554/}' :demux=h264`
- Stream to YouTube `raspivid -o - -t 0 -vf -hf -fps 20 -b 4000000 | ffmpeg -re -ar 44100 -ac 2 -acodec pcm_s16le -f s16le -ac 2 -i /dev/zero -f h264 -thread_queue_size 512 -i - -vcodec copy -acodec aac -ab 128k -g 50 -strict experimental -f flv rtmp://a.rtmp.youtube.com/live2/[your-secret-key-here]`
- Edit /etc/apt/sources.list and add the line `deb http://www.deb-multimedia.org jessie main non-free`
- Run `sudo apt-get update && sudo apt-get install ffmpeg`
