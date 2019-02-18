#!/bin/bash

chown octoprint /home/octoprint/.octoprint
chgrp octoprint /home/octoprint/.octoprint
chmod -R o+rw /home/octoprint/.octoprint

su - octoprint -c /mjpg-streamer/mjpg-streamer-experimental/mjpg_streamer -i "./input_uvc.so -y" -o "./output_http.so" &

su - octoprint -c '~/OctoPrint/venv/bin/octoprint serve'