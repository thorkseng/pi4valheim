FROM debian

# Install tools required for the project
# Run 'docker build --no-cache .' to udpate dependencies
RUN dpkg --add-architecture armhf
RUN apt update && apt full-upgrade -y
RUN apt install -y \
    gcc-arm-linux-gnueabihf \
    git \
    make \
    cmake \
    python3 \
    curl \
    libsdl2-2.0-0 \
    nano
RUN apt install -y \
    libc6:armhf \
    libncurses5:armhf \
    libstdc++6:armhf

# Install the box86 to emulate x86 platform (for steamcmd cliente)
WORKDIR /root
RUN git clone https://github.com/ptitSeb/box86
WORKDIR /root/box86/build
RUN cmake .. -DRPI4ARM64=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo
RUN make -j4; 
RUN make install

# Install steamcmd and download the valheim server:
WORKDIR /root/steam
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
ENV DEBUGGER "/usr/local/bin/box86"
ENV BOX86_DYNAREC "0"
RUN ./steamcmd.sh +@sSteamCmdForcePlatformType linux +login anonymous +force_install_dir /root/valheim_server +app_update 896660 validate +quit

## Box64 installation
WORKDIR /root

# Using alternative repository with memory fix:
# RUN git clone https://github.com/ptitSeb/box64
# WORKDIR /root/box64/build
RUN git clone -b memory-map-fix https://github.com/mogery/box64 box64-memory-patch
WORKDIR /root/box64-memory-patch/build
RUN cmake .. -DRPI4ARM64=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo
RUN make -j4; 
RUN make install

EXPOSE 2456-2458/udp

CMD ["/bin/bash"]
