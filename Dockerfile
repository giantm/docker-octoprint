FROM ubuntu:17.10

# INSTALL PACKAGES
RUN apt update -q && \
    apt upgrade -y && \
    apt dist-upgrade -y 

#install required packages
RUN apt -y install python-pip python-dev python-setuptools python-virtualenv git libyaml-dev build-essential wget libavahi-compat-libdnssd1 curl imagemagick ffmpeg libv4l-dev cmake dbus

ADD etc/avahi/avahi-daemon.conf /etc/avahi/avahi-daemon.conf

#enable dbus service at start
RUN /usr/sbin/update-rc.d dbus enable

#enable avahi service at start
RUN /usr/sbin/update-rc.d avahi-daemon enable

#
# Begin mjpg-streamer setup
#

# install required libs
RUN apt -y install libjpeg8-dev ffmpeg

#get source
RUN git clone https://github.com/jacksonliam/mjpg-streamer.git 

#set lib path
ENV LD_LIBRARY_PATH=/mjpg-streamer/mjpg-streamer-experimental;${LD_LIBRARY_PATH}

# run make
RUN cd mjpg-streamer/mjpg-streamer-experimental && \
	make && \
	make install

#
# resume setting up actual octoprint install
#

#add startup script and make executable
ADD launch.sh /launch.sh 
RUN chmod o+x /launch.sh

#add octoprint user, grant serial permissions to allow printer access
RUN adduser --quiet --disabled-password --disabled-login octoprint && \
	usermod -a -G tty octoprint && \
	usermod -a -G dialout octoprint && \
	usermod -a -G video octoprint 

#switch over to octoprint user to start software install
USER octoprint

#volume for runtime modifiable files to be stored in a volume to preserve state
VOLUME /home/octoprint/.octoprint

#copy in install script 
ADD install.sh /install.sh 

#run install
RUN /bin/bash /install.sh

EXPOSE 5000/tcp

ENTRYPOINT ["/launch.sh"]

