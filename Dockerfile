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
                       git \
                       libeigen3-dev \
                       libopencv-dev \
                       libroscpp-dev \
                       protobuf-compiler \
                       python3-pip \
                       unzip \
                       gazebo9 \
                       libgazebo9-dev \
                       gstreamer1.0-plugins-bad \
                       gstreamer1.0-plugins-base \
                       gstreamer1.0-plugins-good \
                       gstreamer1.0-plugins-ugly \
                       libgstreamer-plugins-base1.0-dev \
                       libgstrtspserver-1.0-dev \
                       xvfb \
                       python3-numpy && \
    apt-get -y autoremove && \
    apt-get clean autoclean && \
    rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/* &&\
    pip3 install empy \
                 jinja2 \
                 packaging \
                 pyros-genmsg \
                 toml \
                 pyyaml &&\
    git clone https://github.com/PX4/Firmware.git ${FIRMWARE_DIR} &&\
    git -C ${FIRMWARE_DIR} checkout master &&\
    git -C ${FIRMWARE_DIR} submodule update --init --recursive

COPY edit_rcS.bash ${WORKSPACE_DIR}
COPY entrypoint.sh /root/entrypoint.sh
COPY sitl_rtsp_proxy ${SITL_RTSP_PROXY}

RUN chmod +x /root/entrypoint.sh &&\
    ["/bin/bash", "-c", " \
    cd ${FIRMWARE_DIR} && \
    DONT_RUN=1 make px4_sitl gazebo && \
    DONT_RUN=1 make px4_sitl gazebo \
"]

RUN cmake -B${SITL_RTSP_PROXY}/build -H${SITL_RTSP_PROXY} &&\
cmake --build ${SITL_RTSP_PROXY}/build


ENTRYPOINT ["/root/entrypoint.sh"]
