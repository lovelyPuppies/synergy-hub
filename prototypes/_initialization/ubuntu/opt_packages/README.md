# How to install packages to `/opt/` from Docker

- [How to install packages to `/opt/` from Docker](#how-to-install-packages-to-opt-from-docker)
  - [🔰 Common settings](#-common-settings)
  - [protobuf-builder](#protobuf-builder)
    - [Run Commands](#run-commands)
    - [Pro-process](#pro-process)
    - [References](#references)
  - [nanoPB](#nanopb)
    - [Run Commands](#run-commands-1)
    - [Pro-process](#pro-process-1)
  - [boost](#boost)
    - [Run Commands](#run-commands-2)
    - [Pro-process](#pro-process-2)

## 🔰 Common settings

- 📝 Note that Almost builded libraries have Version

  - \<package_name\>/**debug-static**
  - \<package_name\>/**debug-shared**
  - \<package_name\>/**release-static**
  - \<package_name\>/**release-shared**

- Shell Environment

  ```bash
  #!/usr/bin/env fish
  set FISH_CONFIG_PATH "$HOME/.config/fish/config.fish"

  function prettify_indent_via_pipe
      awk '
        NR == 2 { indent = match($0, /[^ ]/) - 1 }
        NR > 1 { sub("^ {" indent "}", "") }
        NR == 1 { next }
        { gsub(/[[:blank:]]*$/, ""); print }
      '
  end


  set unique_comment "## Prevent empty values when appending to search path variables in Fish Shell"
  if not grep -Fxq "$unique_comment" "$FISH_CONFIG_PATH"
      echo "
    $unique_comment"'
    set --query CPATH; or set CPATH ""
    set --query LIBRARY_PATH; or set LIBRARY_PATH ""
    set --query LD_LIBRARY_PATH; or set LD_LIBRARY_PATH ""
    set --query PKG_CONFIG_PATH; or set PKG_CONFIG_PATH ""
    ' | prettify_indent_via_pipe | tee -a $FISH_CONFIG_PATH >/dev/null
      echo -e "\n" >>"$FISH_CONFIG_PATH"
  end
  ```

## protobuf-builder

📅 Written at 2025-02-03 04:07:51

### Run Commands

- Build and Set up

  ```bash
  #!/usr/bin/env fish
  sudo -v

  set protobuf_prefix /opt/protobuf

  #### 🌀 Title: Build protobuf
  cd prototypes/_initialization/ubuntu/opt_packages
  ## ⚙️ Adjust the "BRANCH_VERSION" you want 🔗 https://github.com/protocolbuffers/protobuf/tags
  # last updated version I checked: v29.3 📅 2025-02-01 23:17:48
  docker build --build-arg BRANCH_VERSION=v29.3 -t protobuf-builder -f protobuf-builder/Dockerfile protobuf-builder




  #### 🌀 Title: Verify the installed packages from Docker
  ## Check the protobuf version
  docker run --rm --name protobuf-container protobuf-builder ls /opt/protobuf/debug-static/bin/ | grep --extended-regexp 'protoc-[0-9]+'
  #   🛍️ e.g. >> protoc-29.3.0

  ## Check the installed locations
  docker run --rm --name protobuf-container protobuf-builder find /opt/protobuf/ -mindepth 1 -maxdepth 1
  #   >> /opt/protobuf/debug-static
  #   >> /opt/protobuf/release-shared
  #   >> /opt/protobuf/release-static
  #   >> /opt/protobuf/debug-shared




  #### 🌀 Title: Copy the packages to `/opt/` from Docker, and Set Environment variables

  ## create a new container
  # if the same name container exists, remove it.
  docker rm -f protobuf-container &> /dev/null
  docker run -d --name protobuf-container -it protobuf-builder bash

  ## remove previous version
  sudo rm -fr $protobuf_prefix

  ## copy
  sudo docker cp protobuf-container:$protobuf_prefix $protobuf_prefix

  ## remove the container
  docker rm -f protobuf-container


  #### 🌀 Title: Add search paths for headers and libraries
  set unique_comment "## [protobuf] Add search paths for headers and libraries"
  if not grep -Fxq "$unique_comment" "$FISH_CONFIG_PATH"
      echo "
      $unique_comment
      #⚖️ Default: Using the static build for simplicity, portability, and independence.
      # For larger projects requiring shared libraries, consider using CMake, Conan, or pkg-config to manage dependencies and configure linking more flexibly.
      fish_add_path $protobuf_prefix/debug-static/bin
      set -a PKG_CONFIG_PATH $protobuf_prefix/debug-static/lib/pkgconfig
      set -a LD_LIBRARY_PATH $protobuf_prefix/debug-shared/lib
      " | prettify_indent_via_pipe | tee -a $FISH_CONFIG_PATH >/dev/null
      echo -e "\n" >>"$FISH_CONFIG_PATH"
  end
  ```

- Navigate

  ```bash
  #!/usr/bin/env fish
  # 🔘 If the named container is not created
  docker run -it --rm --name protobuf-container protobuf-builder /bin/bash

  # 🔘 If the named container is already created but stopped
  docker start -i protobuf-container

  ## Build log
  mkdir -p $HOME/Downloads/build-logs/protobuf
  docker exec protobuf-container sh -c 'tar -cf - -C /root/protobuf build-*.log' | tar -xvf - -C $HOME/Downloads/build-logs/protobuf
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

- Add into `.clangd` for intellisense

  ```plaintxt
  ---
  If:
    PathExclude: "study/bsp_study/raspberry_pi/.*"
  CompileFlags:
    Add:
      - -I/opt/protobuf/debug-static/include
  ```

### References

- [Building a Dual Shared and Static Library with CMake](https://alexreinking.com/blog/building-a-dual-shared-and-static-library-with-cmake.html)

## nanoPB

📅 Written at 2025-02-03 04:07:51

### Run Commands

- Download and Set up

  🚣 Note that it have only static library!

  ```bash
  #!/usr/bin/env fish
  sudo -v
  sudo apt update && sudo apt install -y curl

  set nanopb_prefix /opt/nanopb

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



  #### 🌀 Title: Download pre-built library
  cd $HOME/Downloads
  ## ⚙️ Adjust the version you want 🔗 https://jpa.kapsi.fi/nanopb/download/
  # last updated version I checked: 0.4.9.1 📅 2025-02-01 23:17:48
  curl -L https://jpa.kapsi.fi/nanopb/download/nanopb-0.4.9.1-linux-x86.tar.gz -o nanopb.tar.gz
  mkdir -p nanopb
  tar -xf nanopb.tar.gz -C nanopb --strip-component=1

  ## create include, bin directory and create symbolic links.
  cd nanopb
  mkdir -p include bin
  ln -s ../generator/nanopb_generator.py bin/nanopb_generator
  ln -s ../pb.h include/
  ln -s ../pb_common.c include/
  ln -s ../pb_common.h include/
  ln -s ../pb_decode.c include/
  ln -s ../pb_decode.h include/
  ln -s ../pb_encode.c include/
  ln -s ../pb_encode.h include/

  ## move the nanopb directory to /opt/nanopb and return to Working directory
  cd -
  sudo mv nanopb $nanopb_prefix
  cd -




  #### 🌀 Title: Add search paths for headers and libraries
  set unique_comment "## [nanoPB] Add search paths for headers and libraries"
  if not grep -Fxq "$unique_comment" "$FISH_CONFIG_PATH"
      echo "
      $unique_comment
      fish_add_path $nanopb_prefix/bin
      set -a CPATH $nanopb_prefix/include
      " | prettify_indent_via_pipe | tee -a $FISH_CONFIG_PATH >/dev/null
      echo -e "\n" >>"$FISH_CONFIG_PATH"
  end
  ```

### Pro-process

- Add into `.clangd` for intellisense

  ```plaintxt
  ---
  If:
    PathExclude: "study/bsp_study/raspberry_pi/.*"
  CompileFlags:
    Add:
      - -I/opt/nanopb/include
  ```

## boost

📅 Written at 2025-02-03 04:07:51

### Run Commands

- Build and Set up

  ```bash
  #!/usr/bin/env fish
  sudo -v

  set boost_prefix /opt/boost

  #### 🌀 Title: Build boost
  cd prototypes/_initialization/ubuntu/opt_packages
  ## ⚙️ Adjust the "BOOST_VERSION" you want 🔗 https://github.com/protocolbuffers/protobuf/tags
  # last updated version I checked: 1.87.0 📅 2025-02-03 02:36:08
  docker build --build-arg BOOST_VERSION=1.87.0 -t boost-builder -f boost-builder/Dockerfile boost-builder




  #### 🌀 Title: Verify the installed packages from Docker
  ## Check the boost version
  docker run --rm --name boost-container boost-builder cat /opt/boost/debug-static/include/boost/version.hpp | grep --fixed-strings '#define BOOST_LIB_VERSION'
  #   🛍️ e.g. >> define BOOST_LIB_VERSION "1_87"

  ## Check the installed locations
  docker run --rm --name boost-container boost-builder find /opt/boost/ -mindepth 1 -maxdepth 1
  #   >> /opt/boost/debug-static
  #   >> /opt/boost/release-shared
  #   >> /opt/boost/release-static
  #   >> /opt/boost/debug-shared





  #### 🌀 Title: Copy the packages to `/opt/` from Docker, and Set Environment variables
  ## create a new container
  # if the same name container exists, remove it.
  docker rm -f boost-container &> /dev/null
  docker run -d --name boost-container -it boost-builder bash

  ## remove previous version
  sudo rm -fr $boost_prefix

  ## copy
  sudo docker cp boost-container:$boost_prefix $boost_prefix

  ## remove the container
  docker rm -f boost-container

  #### 🌀 Title: Add search paths for headers and libraries
  set unique_comment "## [boost] Add search paths for headers and libraries"
  if not grep -Fxq "$unique_comment" "$FISH_CONFIG_PATH"
      echo "
      $unique_comment
      set -a CPATH $boost_prefix/debug-static/include
      set -a LD_LIBRARY_PATH $boost_prefix/debug-shared/lib
      " | prettify_indent_via_pipe | tee -a $FISH_CONFIG_PATH >/dev/null
      echo -e "\n" >>"$FISH_CONFIG_PATH"
  end
  ```

- Navigate

  ```bash
  #!/usr/bin/env fish
  # 🔘 If the named container is not created
  docker run -it --rm --name boost-container boost-builder /bin/bash

  # 🔘 If the named container is already created but stopped
  docker start -i boost-container

  ## Build log
  mkdir -p $HOME/Downloads/build-logs/boost
  docker exec boost-container sh -c 'tar -cf - -C /root/boost build-*.log' | tar -xvf - -C $HOME/Downloads/build-logs/boost
  ```

  - ❔ about `./b2 --help` in Dockerfile

    - --prefix=\<PREFIX\>

      Install architecture independent files here.
      Default: C:\Boost on Windows
      Default: /usr/local on Unix, Linux, etc.

    - --build-dir=DIR

      Build in this location instead of building within the distribution tree. Recommended!

    - toolset=toolset

      Indicate the toolset to build with.

    - variant=debug|release

      Select the build variant

    - link=static|shared

      Whether to build static or shared libraries

    - runtime-link=static|shared

      Whether to link to static or shared C and C++ runtime.

### Pro-process

- Add into `.clangd` for intellisense

  ```plaintxt
  ---
  If:
    PathExclude: "study/bsp_study/raspberry_pi/.*"
  CompileFlags:
    Add:
      - -I/opt/boost/debug-static/include
  ```
