#!/bin/bash

# setup the X400
printf "snd_soc_bcm2708\nsnd_soc_bcm2708_i2s\nbcm2708_dmaengine\nsnd_soc_pcm512x\nsnd_soc_iqaudio_dac"  >> /etc/modules

# re-start gpsd service to pickup new config
/etc/init.d/gpsd restart

# Start the application
npm start
