# How to install packages to `/opt/` from Docker

## protobuf-builder

📅 Written at 2025-02-01 01:00:04

### Run Commands

- Build

  ```bash
  #!/usr/bin/env fish
  cd prototypes/_initialization/ubuntu/opt_packages
  docker build -t protobuf-builder -f protobuf-builder/Dockerfile protobuf-builder
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

- Copy the packages to `/opt/` from Docker, and Set Environment variables

  ```bash
  #!/usr/bin/env fish
  ###
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



  ###
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

### References

- [Building a Dual Shared and Static Library with CMake](https://alexreinking.com/blog/building-a-dual-shared-and-static-library-with-cmake.html)
- brew install protobuf && brew edit protobuf && code /home/linuxbrew/.linuxbrew/Homebrew/Library/Taps/homebrew/homebrew-core/Formula/p/protobuf.rb
