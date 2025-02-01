# How to install packages to `/opt/` from Docker

- [How to install packages to `/opt/` from Docker](#how-to-install-packages-to-opt-from-docker)
  - [protobuf-builder](#protobuf-builder)
    - [Run Commands](#run-commands)
    - [Pro-process](#pro-process)
    - [References](#references)
  - [nanoPB](#nanopb)
    - [Run Commands](#run-commands-1)
    - [Pro-process](#pro-process-1)

## protobuf-builder

📅 Written at 2025-02-01 01:00:04

### Run Commands

- Build and setting for Path

  ```bash
  #!/usr/bin/env fish

  #### 🌀 Title: Build protobuf
  cd prototypes/_initialization/ubuntu/opt_packages
  ## ⚙️ Adjust the "BRANCH_VERSION" you want 🔗 https://github.com/protocolbuffers/protobuf/tags
  # last updated version I checked: v29.3 📅 2025-02-01 23:17:48
  docker build --build-arg BRANCH_VERSION=v29.3 -t protobuf-builder -f protobuf-builder/Dockerfile protobuf-builder




  #### 🌀 Title: Verify the installed packages from Docker
  ## Check the protoc version
  docker run --rm --name protobuf-container protobuf-builder ls /opt/protobuf-static/bin/ | grep -E "protoc-[0-9]+"
  #   >> protoc-30.0.0

  ## Check the installed locations
  docker run --rm --name protobuf-container protobuf-builder ls /opt/
  #   >> protobuf-shared
  #   >> protobuf-static




  #### 🌀 Title: Copy the packages to `/opt/` from Docker, and Set Environment variables
  # create a new container
  docker run --name protobuf-container protobuf-builder
  # docker run -it --name protobuf-container protobuf-builder /bin/bash

  # remove previous version
  sudo rm -fr /opt/protobuf-shared
  sudo rm -fr /opt/protobuf-static

  # copy
  sudo docker cp protobuf-container:/opt/protobuf-shared /opt/protobuf-shared
  sudo docker cp protobuf-container:/opt/protobuf-static /opt/protobuf-static

  # remove the container
  docker rm protobuf-container




  #### 🌀 Title: Add search paths for headers and libraries
  set FISH_CONFIG_PATH "$HOME/.config/fish/config.fish"

  function prettify_indent_via_pipe
      awk '
        NR == 2 { indent = match($0, /[^ ]/) - 1 }
        NR > 1 { sub("^ {" indent "}", "") }
        NR == 1 { next }
        { gsub(/[[:blank:]]*$/, ""); print }
      '
  end

  set protobuf_shared_prefix /opt/protobuf-shared
  set protobuf_static_prefix /opt/protobuf-static
  set unique_comment "## [protobuf] Add search paths for headers and libraries"
  if not grep -Fxq "$unique_comment" "$FISH_CONFIG_PATH"
      echo "
      $unique_comment
      #⚖️ Default: Using the static build for simplicity, portability, and independence.
      # For larger projects requiring shared libraries, consider using CMake, Conan, or pkg-config to manage dependencies and configure linking more flexibly.
      fish_add_path $protobuf_static_prefix/bin
      set -a PKG_CONFIG_PATH $protobuf_static_prefix/lib/pkgconfig
      set -a LD_LIBRARY_PATH $protobuf_shared_prefix/lib
      " | prettify_indent_via_pipe | tee -a $FISH_CONFIG_PATH >/dev/null
      echo -e "\n" >>"$FISH_CONFIG_PATH"
  end
  ```

- Navigate

  ```
  docker start -i protobuf-container
  ```

  - ❔ about CMake args in Dockerfile

    - Build Shared Libraries

      protobuf_BUILD_SHARED_LIBS:BOOL=OFF

    - Build libprotoc

      protobuf_BUILD_LIBPROTOC:BOOL=OFF

    - Build examples

      protobuf_BUILD_EXAMPLES:BOOL=OFF

    - Install the examples folder

      protobuf_INSTALL_EXAMPLES:BOOL=OFF

    - Build tests

      protobuf_BUILD_TESTS:BOOL=ON

### Pro-process

- add into `.clangd` for intellisense

  ```plaintxt
  ---
  If:
    PathExclude: "study/bsp_study/raspberry_pi/.*"
  CompileFlags:
    Add:
      - -I/opt/protobuf-static/include
  ```

### References

- [Building a Dual Shared and Static Library with CMake](https://alexreinking.com/blog/building-a-dual-shared-and-static-library-with-cmake.html)

## nanoPB

### Run Commands

- Add python dependency

```bash
#!/usr/bin/env fish

#### 🌀 Title: Add Python dependency
poetry add grpcio-tools="*"

## From %shell> python generator/nanopb_generator.py message.proto
# >>
#   **********************************************************************
#   *** Could not import the Google protobuf Python libraries          ***
#   ***                                                                ***
#   *** Easiest solution is often to install the dependencies via pip: ***
#   ***    pip install protobuf grpcio-tools                           ***
#   **********************************************************************
```

📰 Doing

```bash
#!/usr/bin/env fish

#### 🌀 Title: Add Python dependency


## ⚙️ Adjust the "BRANCH_VERSION" you want 🔗 https://jpa.kapsi.fi/nanopb/download/
# last updated version I checked: 0.4.9.1 📅 2025-02-01 23:17:48
cd $HOMe/Downloads
curl -L https://jpa.kapsi.fi/nanopb/download/nanopb-0.4.9.1-linux-x86.tar.gz -o nanopb.tar.gz
sudo mkdir -p /opt/nanopb
tar -xvf nanopb-0.4.9.1-linux-x86.tar.gz -C /opt/nanopb --strip-component=1


pb_common.h pb_common.c pb_decode.h pb_decode.c pb_encode.h pb_encode.c


```

### Pro-process

- add into `.clangd` for intellisense

  ```plaintxt
  ---
  If:
    PathExclude: "study/bsp_study/raspberry_pi/.*"
  CompileFlags:
    Add:
      - -I/opt/nanopb
  ```
