#!/bin/bash

# Start gpsd
gpsd /dev/ttyUSB0

# Start the application
npm start
