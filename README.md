# pi4valheim
Experimental Docker file to run a Valheim server in a Raspberry Pi4.

The valheim.Dockerfile is based on the stardart repositories of box86 and box64.

## Compiled image:
You can find in the docker hub the image to run directly: https://hub.docker.com/repository/docker/tranko/pi4valheim

## Requeriments:
Raspberry Pi4: I only tested on a 8GB of RAM with the next requirements:
- [RaspianOs 64 Bits](https://downloads.raspberrypi.org/raspios_arm64/images/raspios_arm64-2020-05-28/) updated.
- Upgrade the distribution to Debian BullsEye (change the repositories to):

```
deb http://deb.debian.org/debian           bullseye          main contrib non-free
deb http://deb.debian.org/debian-security/ bullseye-security main contrib non-free
deb http://deb.debian.org/debian           bullseye-updates  main contrib non-free
```

Then run the typical upgrade of Debian:
```
sudo apt update & sudo apt upgrade & sudo apt dist-upgrade
```

- Install [Podman](https://podman.io/getting-started/installation) v3.3.1 (The version that is in the Debian repository is old (3.0.1) and it does not work correctly in my case).
- Install [Docker](https://docs.docker.com/engine/install/debian/) (Tested on version 20.10.9)

## Create the image (it will take around 1-2 hours)

If you use podman: 

    podman build -f valheim.Dockerfile
    podman image tag c44a18e4e67d valheim-base:v1

If you use docker:

    docker build --no-cache --tag valheim-base -f Valheim.dockerfile .
        
## Execute the container

### First step configure the env.world file:

This values don't be changed. Only if they change in the future:
    
    STEAMAPPID=892970
    BOX64_LD_LIBRARY_PATH=./linux64:/root/steam/linux32:$BOX64_LD_LIBRARY_PATH
    BOX64_LOG=1
    BOX64_TRACE_FILE=/root/valheim_data/output.log
    BOX64_TRACE=1
    
This values are the real ones for yoru server:    
    
    PUBLIC=0                        # 0 private / 1 public
    PORT=2456                       # Don't change if don't know what are you doing. 
    NAME=YourServerName             # Your amazing name of your server.
    WORLD=YourWorldName             # Your unique name of your world.
    SAVEDIR=/root/valheim_data      # Where to save your data.
    PASSWORD=YourUniquePassw0rd     # You can leave blank and it will not have password
                                    # NOT recommended for public servers.

### Second step, run the container (example with Docker):

    docker run --rm --name valheim -p 2456-2457:2456-2457/udp -v /home/pi/ssd/valheim_data:/root/valheim_data:rw --env-file env.tardis valheim-base

## Considerations:
Pi4 has a limited hardware, it this is emulating x86_64 over arm64, so don't expect so high performance. It works, I didn't have any problems playing some hours.
When the game saves it freeze all connections during some seconds, take it into account!!!!! Several times it does not start correctly and fail (the emulator is not yet finished and it does not work all the times). In that cases, you need to stop the process killing the process.

## This experiment can be done for the next projects:
- [box86](https://github.com/ptitSeb/box86)
- [box64](https://github.com/ptitSeb/box64)
- [docker](docker.com)
- [podman](podman.io)
