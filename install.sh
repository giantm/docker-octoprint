#!/bin/bash

cd ~
mkdir OctoPrint && cd OctoPrint
virtualenv venv
source venv/bin/activate
pip install pip --upgrade
pip install pybonjour
pip install https://get.octoprint.org/latest
venv/bin/pip install https://goo.gl/SxQZ06