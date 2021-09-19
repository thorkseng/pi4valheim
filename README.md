# pi4valheim
Experimental Docker file to run a Valheim server in a Raspberry Pi4

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

- Install [Podman](https://podman.io/getting-started/installation) v3.3.1 (Debian repository does not work correctly in my case).

## Create the image (it will take around 1-2 hours)

    podman build -f Valheim.dockerfile
    podman 
        
## Execute the container
In my case, I have my world from previous server in /home/pi/valheim_data.

    podman run --name valheim --network host -v /home/pi/valheim_data:/root/valheim_data:rw -it valheim-base /bin/bash
    
Create a start.sh copy from the start_server.sh and modify the execution with box64 in front
For example I execute my server with the next line to create a local network server to play at home.
    
    box64 ./valheim_server.x86_64 -public 0 -nographics -batchmode -name "Your server Name" -port 2456 -world "Your Workd Name" -savedir "/root/valheim_data"
    
## Considerations:
Pi4 has a limited hardware, it this is emulating x86_64 over arm64, so don't expect so high performance. It works, I didn't have any problems playing some hours.
When the game saves it freeze all connections during some seconds, take it into account!!!!!

## This experiment can be done for the next projects:
podman
- [box86](https://github.com/ptitSeb/box86)
- [box64](https://github.com/ptitSeb/box64)
