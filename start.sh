#!/bin/bash

# re-start gpsd service to pickup new config
/etc/init.d/gpsd restart

# Start the application
npm start
