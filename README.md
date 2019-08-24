# docker-pyinstalive

Run [PyInstaLive](https://github.com/notcammy/PyInstaLive/) continuously using Docker

## Usage

Here are some example snippets to help you get started creating a container.

### docker

```
docker create \
  --name=pyinstalive \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Australia/Sydney \
  -v </path/to/config>:/config \
  -v </path/to/downloads>:/downloads \
  --restart unless-stopped \
  adampetrovic/pyinstalive
```

### docker-compose

Compatible with docker-compose v2 schemas.

```
---
version: "2"
services:
  pyinstalive:
    image: adampetrovic/pyinstalive
    container_name: pyinstalive
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Australia/Sydney
    volumes:
      - </path/to/config>:/config
      - </path/to/downloads>:/downloads
    restart: unless-stopped
```

## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| `-e PUID=1000` | for UserID - see below for explanation |
| `-e PGID=1000` | for GroupID - see below for explanation |
| `-e TZ=Europe/London` | Specify a timezone to use EG Europe/London. |
| `-v /config` | The pyinstalive.ini file lives here. |
| `-v /downloads` | The download volume where instagram lives will be downloaded   |

## User / Group Identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1000` and `PGID=1000`, to find yours use `id user` as below:

```
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```
&nbsp;
## Application Setup

### Validation and initial setup
* Before running this container, it is recommended that you create a pyinstalive.ini file and save it to your /config path. For an example, see /root/defaults/pyinstalive.ini. If one doesn't exist, it will be created on first run of the docker container

## Support Info

* Shell access whilst the container is running: `docker exec -it pyinstalive /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f pyinstalive`
* container version number 
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' pyinstalive`
* image version number
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' adampetrovic/pyinstalive`

## Updating Info
  
### Via Docker Run/Create
* Update the image: `docker pull adampetrovic/pyinstalive`
* Stop the running container: `docker stop pyinstalive`
* Delete the container: `docker rm pyinstalive`
* Recreate a new container with the same docker create parameters as instructed above (if mapped correctly to a host folder, your `/config` folder and settings will be preserved)
* Start the new container: `docker start pyinstalive`
* You can also remove the old dangling images: `docker image prune`

### Via Docker Compose
* Update all images: `docker-compose pull`
  * or update a single image: `docker-compose pull pyinstalive`
* Let compose update all containers as necessary: `docker-compose up -d`
  * or update a single container: `docker-compose up -d pyinstalive`
* You can also remove the old dangling images: `docker image prune`

### Via Watchtower auto-updater (especially useful if you don't remember the original parameters)
* Pull the latest image at its tag and replace it with the same env variables in one run:
  ```
  docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower \
  --run-once pyinstalive
  ```

**Note:** We do not endorse the use of Watchtower as a solution to automated updates of existing Docker containers. In fact we generally discourage automated updates. However, this is a useful tool for one-time manual updates of containers where you have forgotten the original parameters. In the long term, we highly recommend using Docker Compose.

* You can also remove the old dangling images: `docker image prune`

## Building locally

If you want to make local modifications to these images for development purposes or just to customize the logic: 
```
git clone https://github.com/adampetrovic/docker-pyinstalive.git
cd docker-pyinstalive
docker build \
  --no-cache \
  --pull \
  -t adampetrovic/pyinstalive:latest .
```

