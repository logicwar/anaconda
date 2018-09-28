[hub]:https://hub.docker.com/r/logicwar/anaconda/
[anaconda]:https://www.anaconda.com/
[jupyter]:http://jupyter.org/
[tz_wikipedia]:https://en.wikipedia.org/wiki/List_of_tz_database_time_zones

# [Docker Container for Anaconda 5.2.0][hub]

This is a Docker image based on osixia/light-baseimage for running  Anaconda 5.2.0. It start [jupyter][jupyter] and '*cron*' as services (which will restart after quiting or a crashing).

With over 6 million users, the open source Anaconda Distribution is the fastest and easiest way to do Python and R data science and machine learning on Linux, Windows, and Mac OS X. It's the industry standard for developing, testing, and training on a single machine [Anaconda][anaconda].

## Usage (minimal)
```
docker run -it --name=anaconda \ 
              -v <path for data files>:/mnt/data:rw \
              -e DGID=<gid>
              -e DUID=<uid> \
              -e TZ=<timezone> \
              -p 8888:8888 \
              logicwar/anaconda
```
### Start/Stop
You can then start/stop the server with :

* `docker start anaconda` or `docker start -i anaconda` if you want direct interaction
* `docker stop anaconda` 

### Shell access
For shell access while the container is running do :

`docker exec -it anaconda /bin/bash`

### Server interaction
For server interaction you can attach by using :

`docker attach anaconda` and then `Control-p` followed by `Control-q` to detach

From an attached console type `stop` or press `Control-c` to stop the server.

### Data access
If you are not using a 'persistent' volume but the auto-created volume, then you can determine it by using :

`docker inspect -f '{{ .Mounts }}' anaconda`

It will return something like this :
```
[{volume 6f58390b223b8427a8515ea4aad9279e4ed618d2e2eb1d425e0d6f98d88fec6c /var/lib/docker/volumes/6f58390b223b8427a8515ea4aad9279e4ed618d2e2eb1d425e0d6f98d88fec6c/_data /mnt/data local  true }]
```
You will then need **root** rights to access the `/var/lib/docker/volumes/6f5839...8fec6c/_data` folder.

## Parameters
* `-p 8888` - jupyter port
* `-v /mnt/data` - local path for the installation
* `-e DGID` for GroupID - see below for explanation
* `-e DUID` for UserID - see below for explanation
* `-e TZ` for timezone information : Europe/London, Europe/Zurich, America/New_York, ... ([List of TZ][tz_wikipedia])

### User / Group ID

For security reasons and to avoid permissions issues with data volumes (`-v` flags), you may want to create a specific "docker" user with proper right accesses on your persistant folders. To find your user **uid** and **gid** you can use the `id <user>` command as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

and finally specify your "docker" user `DUID` and group `DGID`. In this exemple `DUID=1001` and `DGID=1001`.

## Sample of a simple docker-compose.yml
```
version: "3"

services:
  anaconda:
    image: logicwar/anaconda:latest
    volumes:
      - "/MyContainerPersistentMounts/Anaconda/Data:/mnt/data:rw"
    ports:
      - "8888:8888"
    environment:
      DUID: "1004"
      DGID: "1003"
      TZ: "Europe/Zurich"
    container_name: "anaconda-1"
    hostname: "anaconda-1"
    network_mode: "bridge"
    tty: true
    stdin_open: true
```


## Versions
+ **V0.1** Initial Release
