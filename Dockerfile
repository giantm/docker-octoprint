FROM ubuntu:17.10

# INSTALL PACKAGES
RUN apt update -q && \
    apt upgrade -y && \
    apt dist-upgrade -y 

#install image building support
RUN apt -y install python-pip python-dev python-setuptools python-virtualenv git libyaml-dev build-essential wget libavahi-compat-libdnssd1 curl imagemagick ffmpeg libv4l-dev cmake

RUN apt -y install libjpeg8-dev

RUN git clone https://github.com/jacksonliam/mjpg-streamer.git && \
	cd mjpg-streamer/mjpg-streamer-experimental && \
	export LD_LIBRARY_PATH=. && \
	make && \
	make install

#RUN mkdir stage && cd stage && \
#    curl https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/pybonjour/pybonjour-1.1.1.tar.gz | gunzip | tar -x

ADD launch.sh /launch.sh 
RUN chmod o+x /launch.sh

#add octoprint user
RUN adduser --quiet --disabled-password --disabled-login octoprint && \
	usermod -a  -G tty octoprint && \
	usermod -a -G dialout octoprint

USER octoprint

VOLUME /home/octoprint/.octoprint

#copy in install script 
ADD install.sh /install.sh 

#run install
RUN /bin/bash /install.sh

ENTRYPOINT ["/launch.sh"]

