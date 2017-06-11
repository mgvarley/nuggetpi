#!/bin/bash

# Start gpsd
gpsd /dev/ttyUSB0

# Install serve for static files TODO: Move to nginx
npm install -g serve

# Start the main application
serve -s build -p 80
