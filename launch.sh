#!/bin/bash

service dbus start

service avahi-daemon start

#start mjpeg streamers
su - octoprint -c 'cd /mjpg-streamer/mjpg-streamer-experimental && \
	 export LD_LIBRARY_PATH=. && \
	 mjpg_streamer -i "./input_uvc.so -y" -o "./output_http.so" &'

chown octoprint /home/octoprint/.octoprint
chgrp octoprint /home/octoprint/.octoprint
chmod -R o+rw /home/octoprint/.octoprint

#start octoprints
su - octoprint -c '~/OctoPrint/venv/bin/octoprint serve'