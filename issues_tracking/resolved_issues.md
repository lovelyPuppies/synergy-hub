### [Cross-compiling Qt for a 32-bit Raspberry Pi does not work well](https://github.com/PhysicsX/QTonRaspberryPi/issues/21)

Checked on 📅 2025-01-12 18:36:40

Prerequsite

- OS:
  - Kubuntu 24.10
- modify DockerFileRasp
  - to `FROM arm32v7/debian:bookworm` from `FROM arm64v8/debian:bookworm`
- modify buildx command ("linux/arm/v7")
  - to `docker buildx build --platform linux/arm/v7 --load -f DockerFileRasp -t raspimage .`

Description

- I don't know which stage in Docker Build I'm wrong at. I want to search the log. How can I do that?
- I have already tried resetting everything with docker prune and attempted the process two more times (each build taking 3–4 hours). However, the issue persists.
- A similar issue occurred with a 64-bit cross-compilation process, where the same error happened three times. Strangely, it eventually built successfully one day, but I have no idea what changed.

How to reproduct

- Run in shell

  ```bash
  docker buildx build --platform linux/arm/v7 --load -f DockerFileRasp -t raspimage . && \
  docker create --name temp-arm raspimage && \
  docker cp temp-arm:/build/rasp.tar.gz ./rasp.tar.gz && \
  docker build --no-cache -t qtcrossbuild . && \
  docker create --name tmpbuild qtcrossbuild && \
  docker cp tmpbuild:/build/project/HelloQt6 ./qt6.8.0-arm32v7-bookworm-app-Hello && \
  file qt6.8.0-arm32v7-bookworm-app-Hello && \
  docker cp tmpbuild:/build/qt-pi-binaries.tar.gz ./qt6.8.0-arm32v7-bookworm-dev_env.tar.gz
  ```

- output

  ```
  [+] Building 405.2s (8/9)                                                                                                              docker-container:mybuilder
   => [internal] load build definition from DockerFileRasp                                                                                                     0.2s
   => => transferring dockerfile: 2.56kB                                                                                                                       0.0s
   => [internal] load metadata for docker.io/arm32v7/debian:bookworm                                                                                           2.3s
   => [auth] arm32v7/debian:pull token for registry-1.docker.io                                                                                                0.0s
   => [internal] load .dockerignore                                                                                                                            0.1s
   => => transferring context: 2B                                                                                                                              0.0s
   => [1/5] FROM docker.io/arm32v7/debian:bookworm@sha256:1c7160e2d494e213e98e1bd1a8c76a78b24eb297ccd8a067e91de3cb0e2adde9                                     5.1s
   => => resolve docker.io/arm32v7/debian:bookworm@sha256:1c7160e2d494e213e98e1bd1a8c76a78b24eb297ccd8a067e91de3cb0e2adde9                                     0.1s
   => => sha256:e5492f1033203c78872d1ddcc5f604ba35c18b30ac50e9f89180b9d7dfa33fb9 44.20MB / 44.20MB                                                             4.3s
   => => extracting sha256:e5492f1033203c78872d1ddcc5f604ba35c18b30ac50e9f89180b9d7dfa33fb9               [+] Building 516.9s (11/11) FINISHED                                         docker-container:mybuilder
   => [internal] load build definition from DockerFileRasp                                           0.2s
   => => transferring dockerfile: 2.56kB                                                             0.0s
   => [internal] load metadata for docker.io/arm32v7/debian:bookworm                                 2.3so
   => [auth] arm32v7/debian:pull token for registry-1.docker.io                                      0.0s
   => [internal] load .dockerignore                                                                  0.1s
   => => transferring context: 2B                                                                    0.0s
   => [1/5] FROM docker.io/arm32v7/debian:bookworm@sha256:1c7160e2d494e213e98e1bd1a8c76a78b24eb297c  5.1s
   => => resolve docker.io/arm32v7/debian:bookworm@sha256:1c7160e2d494e213e98e1bd1a8c76a78b24eb297c  0.1s
   => => sha256:e5492f1033203c78872d1ddcc5f604ba35c18b30ac50e9f89180b9d7dfa33fb9 44.20MB / 44.20MB   4.3s
   => => extracting sha256:e5492f1033203c78872d1ddcc5f604ba35c18b30ac50e9f89180b9d7dfa33fb9          0.5s
   => [2/5] RUN touch /build.log                                                                     0.3s
   => [3/5] RUN {     echo "deb http://deb.debian.org/debian bookworm main contrib non-free" > /e  393.4s
   => [4/5] WORKDIR /build                                                                           0.3s
   => [5/5] RUN tar cvfz rasp.tar.gz -C / lib usr/include usr/lib                                   75.5s
   => exporting to docker image format                                                              39.2s
   => => exporting layers                                                                           26.5s
   => => exporting manifest sha256:a365fbe8825530048abce51d339410dcc90679c553e6b05de28035d35fa02b59  0.1s
   => => exporting config sha256:fc3b7c78a4b0e46f6c32820239ab0eaab5647120765246ec79501c6123a0ee11    0.0s
   => => sending tarball                                                                            12.7s
   => importing to docker                                                                            9.5s
   => => loading layer d801be16a882 458.75kB / 44.20MB                                               9.5s
   => => loading layer 9ab0836d9cdf 97B / 97B                                                        8.9s
   => => loading layer 56cff60516b3 391.61MB / 488.99MB                                              8.8s
   => => loading layer 51980613a4ee 95B / 95B                                                        0.7s
   => => loading layer 880ee99c85d9 557.06kB / 305.40MB                                              0.6s
  WARNING: The requested image's platform (linux/arm/v7) does not match the detected host platform (linux/amd64/v4) and no specific platform was requested
  86be4f4b688dc88b3e8262375fdaf44e56dc11971140f770c2382d737e576d1d
  Successfully copied 308MB to /home/wbfw109v2/repos/QTonRaspberryPi/rasp.tar.gz
  [+] Building 11010.9s (20/20) FINISHED                                                   docker:default
   => [internal] load build definition from Dockerfile                                               0.1s
   => => transferring dockerfile: 5.70kB                                                             0.0s
   => [internal] load metadata for docker.io/library/debian:bookworm                                 2.2s
   => [auth] library/debian:pull token for registry-1.docker.io                                      0.0s
   => [internal] load .dockerignore                                                                  0.1s
   => => transferring context: 2B                                                                    0.0s
   => [ 1/14] FROM docker.io/library/debian:bookworm@sha256:b877a1a3fdf02469440f1768cf69c9771338a87  5.9s
   => => resolve docker.io/library/debian:bookworm@sha256:b877a1a3fdf02469440f1768cf69c9771338a875b  0.1s
   => => sha256:b877a1a3fdf02469440f1768cf69c9771338a875b7add5e80c45b756c92ac20a 8.52kB / 8.52kB     0.0s
   => => sha256:cd73f5c112f19fac6d67b49d8982104fcf9c14b4ad69c2658fab8702f61b4430 1.02kB / 1.02kB     0.0s
   => => sha256:11c49840db5438765202fd3f2251fcacdf4776faaa3fc018a462bf354963623f 453B / 453B         0.0s
   => => sha256:0a96bdb8280554b560ffee0f2e5f9843dc7b625f28192021ee103ecbcc2d629b 48.50MB / 48.50MB   4.9s
   => => extracting sha256:0a96bdb8280554b560ffee0f2e5f9843dc7b625f28192021ee103ecbcc2d629b          0.6s
   => [internal] load build context                                                                  0.8s
   => => transferring context: 308.14MB                                                              0.6s
   => [ 2/14] RUN {     set -e &&     apt-get update && apt-get install -y     wget     git     b  123.2s
   => [ 3/14] WORKDIR /build                                                                         0.2s
   => [ 4/14] RUN mkdir sysroot sysroot/usr sysroot/opt                                              0.3s
   => [ 5/14] COPY rasp.tar.gz /build/rasp.tar.gz                                                    0.4s
   => [ 6/14] RUN tar xvfz /build/rasp.tar.gz -C /build/sysroot                                      5.3s
   => [ 7/14] COPY toolchain.cmake /build/                                                           0.2s
   => [ 8/14] RUN {     echo "Building CMake from source" &&     mkdir cmakeBuild && cd cmakeBuil  412.4s
   => [ 9/14] RUN {     set -e &&     echo "Fix symbollic link" &&     wget https://raw.githubu  10428.0s
   => [10/14] RUN tar -czvf qt-host-binaries.tar.gz -C /build/qt6/host .                             5.8s
   => [11/14] RUN tar -czvf qt-pi-binaries.tar.gz -C /build/qt6/pi .                                 0.7s
   => [12/14] RUN mkdir /build/project                                                               0.4s
   => [13/14] COPY project /build/project                                                            0.2s
   => [14/14] RUN {     cd /build/project &&     /build/qt6/pi/bin/qt-cmake . &&     cmake --build   0.4s
   => exporting to image                                                                            24.5s
   => => exporting layers                                                                           24.4s
   => => writing image sha256:a336fe730de4177c2e4833a72554e542ffdc94eb9b9cf5c1330d57ca7ae735b2       0.0s
   => => naming to docker.io/library/qtcrossbuild                                                    0.0s
  cf309e722c04175f699504d6b17d9fd717af2f9f9059cc475e6beaab2b0687df
  Error response from daemon: Could not find the file /build/project/HelloQt6 in container tmpbuild
  ⏎
  ```
