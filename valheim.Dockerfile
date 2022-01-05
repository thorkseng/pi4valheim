FROM debian

LABEL maintainer="Tranko"

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
# RUN export DEBUGGER="/usr/local/bin/box86"
ENV BOX86_DYNAREC "0"
ENV DEBUGGER "/usr/local/bin/box86"
RUN ./steamcmd.sh +@sSteamCmdForcePlatformType linux +login anonymous +force_install_dir /root/valheim_server +app_update 896660 validate +quit

## Box64 installation
WORKDIR /root
RUN git clone https://github.com/ptitSeb/box64
WORKDIR /root/box64/build
RUN cmake .. -DRPI4ARM64=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo
RUN make -j4; 
RUN make install

# Cleaning the image
RUN apt-get purge -y wget
RUN rm -r /root/box86
RUN rm -r /root/box64

# Specific for run Valheim server
EXPOSE 2456-2457/udp
WORKDIR /root
COPY bootstrap .
CMD ["/root/bootstrap"]
