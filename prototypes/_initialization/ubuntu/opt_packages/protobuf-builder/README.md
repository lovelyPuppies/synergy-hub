# How to install protobuf packages from Docker

📅 Written at 2025-02-01 01:00:04

## Run Commands

- Build

  ```bash
  #!/usr/bin/env fish
  cd prototypes/_initialization/ubuntu/opt_packages
  docker build -t protobuf-builder -f protobuf-builder/Dockerfile protobuf-builder
  ```

- Verify the installed packages from Docker

  ```bash
  #!/usr/bin/env fish
  ## Check the protoc version
  docker run --rm --name protobuf-container protobuf-builder ls /opt/protobuf-static/bin/ | grep -E "protoc-[0-9]+"
  #   >> protoc-30.0.0

  ## Check the installed locations
  docker run --rm --name protobuf-container protobuf-builder ls /opt/
  #   >> protobuf-shared
  #   >> protobuf-static
  ```

- Copy the packages to `/opt/` from Docker

  ```bash
  #!/usr/bin/env fish
  # create a new container
  docker run --name protobuf-container protobuf-builder

  # copy
  sudo docker cp protobuf-container:/opt/protobuf-shared /opt/protobuf-shared
  sudo docker cp protobuf-container:/opt/protobuf-static /opt/protobuf-static

  # remove the container
  docker rm protobuf-container
  ```

## References

- [Building a Dual Shared and Static Library with CMake](https://alexreinking.com/blog/building-a-dual-shared-and-static-library-with-cmake.html)
