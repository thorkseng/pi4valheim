# pi4valheim
Experimental Docker file to run a Valheim server in a Raspberry Pi4.

The valheim.Dockerfile is based on the stardart repositories of box86 and box64.

## Changelog
2022.10.02: updated with new version of Valheim (0.211.7) with the crossplay parameter.  
2022.10.05: tested with the new version 0.211.8 (no other changes)  
2022.10.13: tested with the new version 0.211.9 (no other changes)  
2022.11.19: tested with the new version 0.211.11 (no other changes)  
2022.11.24: added optimizer dockerfiel for ODROID N2/N2+ (thanks rstrube)  
2022.11.30: now the docker file only downloads the last "stable" releases of box86 and box64 instead the dev code from the main repository  
2022.12.19: removing podman from readme instructions

## Compiled image:
You can find in the docker hub the image to run directly: [https://hub.docker.com/r/tranko/pi4valheim](https://hub.docker.com/r/tranko/pi4valheim)

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

- Install [Docker](https://docs.docker.com/engine/install/debian/) (Tested on version 20.10.9)

## Create the image (it will take around 1-2 hours)
### If you have a Raspberry Pi4

    docker build --no-cache --tag valheim-base -f valheim.Dockerfile .

## if you have a ODROID N2/N2+

    docker build --no-cache --tag valheim-base -f valheim.dodroidn2.Dockerfile .

## Execute the container

### First step configure the env.world file:

This values shouldn't be changed. Only if they change in the future:
    
    STEAMAPPID=892970
    BOX64_LD_LIBRARY_PATH=./linux64:/root/steam/linux32:$BOX64_LD_LIBRARY_PATH
    BOX64_LOG=1
    BOX64_TRACE_FILE=/root/valheim_data/output.log
    BOX64_TRACE=1
    
This values are the real ones for your server:    
    
    PUBLIC=0                        # 0 private / 1 public
    PORT=2456                       # Don't change if don't know what are you doing. 
    NAME=YourServerName             # Your amazing name of your server.
    WORLD=YourWorldName             # Your unique name of your world.
    SAVEDIR=/root/valheim_data      # Where to save your data.
    PASSWORD=YourUniquePassw0rd     # You can leave blank and it will not have password
                                    # NOT recommended for public servers.

### Second step, run the container (example with Docker):

    docker run --rm --stop-signal SIGINT --stop-timeout 100 --name valheim -p 2456-2457:2456-2457/udp -v /valheim_data:/root/valheim_data:rw --env-file env.world valheim-base

## Considerations:
Pi4 has a limited hardware, it this is emulating x86_64 over arm64, so don't expect so high performance. It works, I didn't have any problems playing some hours.
When the game saves it freeze all connections during some seconds, take it into account!!!!! Several times it does not start correctly and fail (the emulator is not yet finished and it does not work all the times). In that cases, you need to stop the process killing the process.

## This experiment has been able to be done thanks to the following open source projects:
- [box86](https://github.com/ptitSeb/box86)
- [box64](https://github.com/ptitSeb/box64)
- [docker](docker.com)
