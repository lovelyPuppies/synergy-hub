# Guide for Using synergy-hub-lfs-backup Docker Image

📅 Written at 2025-01-02 03:35:50

- [Guide for Using synergy-hub-lfs-backup Docker Image](#guide-for-using-synergy-hub-lfs-backup-docker-image)
  - [Build the Image](#build-the-image)
  - [Push the Image to Docker Hub](#push-the-image-to-docker-hub)
    - [Prerequisites for Docker Push](#prerequisites-for-docker-push)
    - [Push to Docker Hub](#push-to-docker-hub)
  - [Write Repository Overview on Docker Hub](#write-repository-overview-on-docker-hub)
  - [1️⃣ Pull the Image from Docker Hub](#1️⃣-pull-the-image-from-docker-hub)
  - [2️⃣ Accessing the Image](#2️⃣-accessing-the-image)
    - [➡️ **Normal Usage**; create a container and copy the files to the host system.](#️-normal-usage-create-a-container-and-copy-the-files-to-the-host-system)
  - [Testing the Image](#testing-the-image)
  - [Output sources](#output-sources)

## Build the Image

To build the Docker image, use the following command:

```bash
#!/usr/bin/env fish
docker build -t $docker_hub_user/synergy-hub-lfs-backup:0.1 .
```

- 🛍️ e.g.

  ```bash
  #!/usr/bin/env fish
  docker build -t wbfw109v2/synergy-hub-lfs-backup:0.1 .

  ##### 🌴 OR
  # Alternatively, you can use a generic name without specifying the Docker Hub username:
  docker build -t synergy-hub-lfs-backup:0.1 .
  #❕ But if you plan to push the image to Docker Hub later, you must add your Docker Hub username. This can be done by retagging the image:
  #   docker tag synergy-hub-lfs-backup:0.1 $docker_hub_user/synergy-hub-lfs-backup:0.1
  docker tag synergy-hub-lfs-backup:0.1 wbfw109v2/synergy-hub-lfs-backup:0.1
  ```

## Push the Image to Docker Hub

### Prerequisites for Docker Push

Before pushing the Docker image to Docker Hub, ensure the following:

1. **Log in to Docker Hub**:

   ```bash
   #!/usr/bin/env fish
   docker login
   ```

2. **Tag the Image as `latest`**:

   If not already tagged, add the `latest` tag to the image:

   ```bash
   #!/usr/bin/env fish
   docker tag $docker_hub_user/synergy-hub-lfs-backup:0.1 $docker_hub_user/synergy-hub-lfs-backup:latest
   ```

   - 🛍️ e.g.

     ```bash
     #!/usr/bin/env fish
     docker tag wbfw109v2/synergy-hub-lfs-backup:0.1 wbfw109v2/synergy-hub-lfs-backup:latest
     ```

### Push to Docker Hub

```bash
#!/usr/bin/env fish
docker push $docker_hub_user/synergy-hub-lfs-backup:0.1
docker push $docker_hub_user/synergy-hub-lfs-backup:latest
```

- 🛍️ e.g.

  ```bash
  #!/usr/bin/env fish
  docker push wbfw109v2/synergy-hub-lfs-backup:0.1
  docker push wbfw109v2/synergy-hub-lfs-backup:latest
  ```

## Write Repository Overview on Docker Hub

Set the repository overview with the following content:

>     Refer to https://github.com/lovelyPuppies/synergy-hub/tree/main/prototypes/_initialization/lfs

## 1️⃣ [Pull the Image from Docker Hub](https://hub.docker.com/r/wbfw109v2/synergy-hub-lfs-backup)

To pull the image, use the following command:

```bash
#!/usr/bin/env fish
docker pull $docker_hub_user/synergy-hub-lfs-backup:latest
```

- 🛍️ e.g.

  ```bash
  #!/usr/bin/env fish
  docker pull wbfw109v2/synergy-hub-lfs-backup
  ```

## 2️⃣ Accessing the Image

To check the files within the container, you can run it interactively:

```bash
#!/usr/bin/env fish
docker run -it --rm $docker_hub_user/synergy-hub-lfs-backup
```

- 🛍️ e.g.

  ```bash
  #!/usr/bin/env fish
  docker run -it --rm wbfw109v2/synergy-hub-lfs-backup
  ```

### ➡️ **Normal Usage**; create a container and copy the files to the host system.

1. Create a named container:

   ```bash
   #!/usr/bin/env fish
   docker create --name synergy-hub-lfs $docker_hub_user/synergy-hub-lfs-backup
   ```

   - 🛍️ e.g.

     ```bash
     #!/usr/bin/env fish
     docker create --name synergy-hub-lfs wbfw109v2/synergy-hub-lfs-backup
     ```

2. Copy the files from the container:

   ```bash
   #!/usr/bin/env fish
   docker cp synergy-hub-lfs:/files/ ./
   ```

3. Clean up the container after copying:
   ```bash
   #!/usr/bin/env fish
   docker rm synergy-hub-lfs
   ```

## Testing the Image

To test the image:

1. Remove any local copies:
   ```bash
   #!/usr/bin/env fish
   docker rmi synergy-hub-lfs-backup
   ```
2. Pull the latest image from Docker Hub:

   ```bash
   #!/usr/bin/env fish
   docker pull $docker_hub_user/synergy-hub-lfs-backup:latest
   ```

   - 🛍️ e.g.

     ```bash
     #!/usr/bin/env fish
     docker pull wbfw109v2/synergy-hub-lfs-backup:latest
     ```

## Output sources

- Build output from [PhysicsX/QTonRaspberryPi](https://github.com/PhysicsX/QTonRaspberryPi/tree/main)
  - qt6.8.0-arm64v8-bookworm-dev_env.tar.gz
  - qt6.8.0-arm64v8-bookworm-app-Hello
  - qt6.8.0-arm32v7-bookworm-dev_env.tar.gz
  - qt6.8.0-arm32v7-bookworm-app-Hello
