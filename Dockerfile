Skip to content
Search or jump to…
Pull requests
Issues
Marketplace
Explore
 
@andrekuros 
JonasVautherin
/
px4-gazebo-headless
Public
Code
Issues
3
Pull requests
Actions
Projects
Wiki
Security
Insights
px4-gazebo-headless/Dockerfile
@JonasVautherin
JonasVautherin Fix upstream build
Latest commit fb8285a on 12 Aug 2021
 History
 3 contributors
@julianoes@JonasVautherin@MartijnGevaert
63 lines (54 sloc)  2 KB
   
FROM ubuntu:18.04

ENV WORKSPACE_DIR /root
ENV FIRMWARE_DIR ${WORKSPACE_DIR}/Firmware
ENV SITL_RTSP_PROXY ${WORKSPACE_DIR}/sitl_rtsp_proxy

ENV DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
ENV DISPLAY :99
ENV LANG C.UTF-8

RUN apt-get update && \
    apt-get install -y bc \
                       cmake \
                       curl \
                       gazebo9 \
                       git \
                       gstreamer1.0-plugins-bad \
                       gstreamer1.0-plugins-base \
                       gstreamer1.0-plugins-good \
                       gstreamer1.0-plugins-ugly \
                       iproute2 \
                       libeigen3-dev \
                       libgazebo9-dev \
                       libgstreamer-plugins-base1.0-dev \
                       libgstrtspserver-1.0-dev \
                       libopencv-dev \
                       libroscpp-dev \
                       protobuf-compiler \
                       python3-jsonschema \
                       python3-numpy \
                       python3-pip \
                       unzip \
                       xvfb && \
    apt-get -y autoremove && \
    apt-get clean autoclean && \
    rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*

RUN pip3 install empy \
                 jinja2 \
                 packaging \
                 pyros-genmsg \
                 toml \
                 pyyaml

RUN git clone https://github.com/PX4/PX4-Autopilot.git ${FIRMWARE_DIR}
RUN git -C ${FIRMWARE_DIR} checkout master
RUN git -C ${FIRMWARE_DIR} submodule update --init --recursive

COPY edit_rcS.bash ${WORKSPACE_DIR}
COPY entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh

RUN ["/bin/bash", "-c", " \
    cd ${FIRMWARE_DIR} && \
    DONT_RUN=1 make px4_sitl gazebo && \
    DONT_RUN=1 make px4_sitl gazebo \
"]

COPY sitl_rtsp_proxy ${SITL_RTSP_PROXY}
RUN cmake -B${SITL_RTSP_PROXY}/build -H${SITL_RTSP_PROXY}
RUN cmake --build ${SITL_RTSP_PROXY}/build

ENTRYPOINT ["/root/entrypoint.sh"]
© 2022 GitHub, Inc.
Terms
Privacy
Security
Status
Docs
Contact GitHub
Pricing
API
Training
Blog
About
Loading complete
