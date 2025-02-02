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

## 🔰 Common settings

📝 Note that all installed libraries is **for Release**. not DEBUG.

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

📅 Written at 2025-02-01 01:00:04

### Run Commands

- Build and setting for Path

  ```bash
  #!/usr/bin/env fish
  sudo -v

  set protobuf_shared_prefix /opt/protobuf-shared
  set protobuf_static_prefix /opt/protobuf-static

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
  sudo rm -fr $protobuf_shared_prefix
  sudo rm -fr $protobuf_static_prefix

  # copy
  sudo docker cp protobuf-container:$protobuf_shared_prefix $protobuf_shared_prefix
  sudo docker cp protobuf-container:$protobuf_static_prefix $protobuf_static_prefix

  # remove the container
  docker rm protobuf-container




  #### 🌀 Title: Add search paths for headers and libraries
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

- Add into `.clangd` for intellisense

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

- Download and setting for Path

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

📰 Doing

### Run Commands

- Build and setting for Path

```bash
#!/usr/bin/env fish
sudo -v

set protobuf_shared_prefix /opt/protobuf-shared
set protobuf_static_prefix /opt/protobuf-static

#### 🌀 Title: Build boost
cd prototypes/_initialization/ubuntu/opt_packages
## ⚙️ Adjust the "BRANCH_VERSION" you want 🔗 https://github.com/protocolbuffers/protobuf/tags
# last updated version I checked: 1.87.0 📅 2025-02-03 02:36:08
docker build --build-arg BOOST_VERSION=1.87.0 -t boost-builder -f boost-builder/Dockerfile boost-builder




sudo apt update && sudo apt install -y curl libicu-dev libopenmpi-dev

boost_prefix=/opt/boost

## ☑️ when run `./bootstrap.sh`
#   >> Unicode/ICU support for Boost.Regex?... not found.
#   ➡️ The package `libicu-dev` is required. 🪱 ICU(International Components for Unicode)
#     After install that, >> Unicode/ICU support for Boost.Regex?... /usr
## ☑️ when run `b2 install`
#   >> error: No best alternative for /boost/libs/mpi/build/boost_mpi with ...
#     matched: (empty)
#     ...
#     MPI auto-detection failed: unknown wrapper compiler mpic++
#     You will need to manually configure MPI support.
#     ...
#     warning: Graph library does not contain MPI-based parallel components.
#     note: to enable them, add "using mpi ;" to your user-config.jam.
#     note: to suppress this message, pass "--without-graph_parallel" to bjam.
#   ➡️ The package `libopenmpi-dev` is required and to run command `echo "using mpi ;" > user-config.jam`  is required.
## ❔ warning: No python installation configured and autoconfiguration
#   note: failed.  See http://www.boost.org/libs/python/doc/building.html
#   note: for configuration instructions or pass --without-python to
#   note: suppress this message and silently skip all Boost.Python targets
#       - BOOST_ARCH_WORD_BITS == 0.0.16 : no [4]
#   ➡️ For this builder, Python wrapping is not required.

cd $HOME/Downloads
## ⚙️ Adjust the version you want 🔗 https://jpa.kapsi.fi/nanopb/download/
# last updated version I checked: 0.4.9.1 📅 2025-02-01 23:17:48
curl -L https://github.com/boostorg/boost/releases/download/boost-1.87.0/boost-1.87.0-cmake.tar.gz -o boost.tar.gz
mkdir -p boost && tar -xf boost.tar.gz -C boost --strip-component=1
cd boost
echo "using mpi ;" > user-config.jam

# https://www.boost.org/doc/libs/1_87_0/more/getting_started/unix-variants.html#easy-build-and-install
./bootstrap.sh
./b2 install --user-config=user-config.jam --without-python --prefix=$boost_prefix/debug-static --build-dir=build/debug-static threading=multi variant=debug link=static runtime-link=shared
./b2 install --user-config=user-config.jam --without-python --prefix=$boost_prefix/debug-shared --build-dir=build/debug-shared threading=multi variant=debug link=shared runtime-link=shared
./b2 install --user-config=user-config.jam --without-python --prefix=$boost_prefix/release-static --build-dir=build/release-static threading=multi variant=release link=static runtime-link=shared
./b2 install --user-config=user-config.jam --without-python --prefix=$boost_prefix/release-shared --build-dir=build/release-shared threading=multi variant=release link=shared runtime-link=shared




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
sudo rm -fr $protobuf_shared_prefix
sudo rm -fr $protobuf_static_prefix

# copy
sudo docker cp protobuf-container:$protobuf_shared_prefix $protobuf_shared_prefix
sudo docker cp protobuf-container:$protobuf_static_prefix $protobuf_static_prefix

# remove the container
docker rm protobuf-container




#### 🌀 Title: Add search paths for headers and libraries
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


sudo docker cp gracious_hertz:/opt/boost /opt/boost

set -a CPATH /opt/boost/debug-static/include
set -a LD_LIBRARY_PATH /opt/boost/debug-shared/lib

# cat /opt/boost/debug-static/include/boost/version.hpp | grep "#define BOOST_LIB_VERSION"
```

- Navigate

  ```
  docker start -i boost-container

  build-debug-static.log
  build-debug-shared.log
  build-release-static.log
  build-release-shared.log
  ```

  - ❔ about `./b2 --help` in Dockerfile

    - --prefix=\<PREFIX\>

      Install architecture independent files here.
      Default: C:\Boost on Windows
      Default: /usr/local on Unix, Linux, etc.

    - --build-dir=DIR

      Build in this location instead of building within the distribution tree. Recommended!

    - variant=debug|release

      Select the build variant

    - link=static|shared

      Whether to build static or shared libraries

    - runtime-link=static|shared

      Whether to link to static or shared C and C++ runtime.
