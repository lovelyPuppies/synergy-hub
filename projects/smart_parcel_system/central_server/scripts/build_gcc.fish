#!/usr/bin/env fish

## 🔗 https://forums.raspberrypi.com/viewtopic.php?t=333170#p1994511
set VERSION 14.2.0
set LANG c,c++

#
#  For any computer with less than 2GB of memory.
#
#if [ -f /etc/dphys-swapfile ]; then
#  sudo sed -i 's/^CONF_SWAPSIZE=[0-9]*$/CONF_SWAPSIZE=2048/' /etc/dphys-swapfile
#  sudo /etc/init.d/dphys-swapfile restart
#fi

if test -d gcc-$VERSION
    cd gcc-$VERSION
    rm -rf build-libstdc++
    # 🧮 aarch64-linux-gnu-g++ -print-search-dirs
    # 🧮 aarch64-linux-gnu-g++ -print-file-name=include

else
    wget http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-$VERSION/gcc-$VERSION.tar.xz
    tar xf gcc-$VERSION.tar.xz
    rm -f gcc-$VERSION.tar.xz
    cd gcc-$VERSION
    contrib/download_prerequisites
end
mkdir -p build-libstdc++
cd build-libstdc++


../libstdc++-v3/configure \
    --build=(../config.guess) \
    --prefix=/usr/local/aarch64-linux-gnu \
    --disable-multilib \
    --disable-nls \
    --disable-libstdcxx-pch
# --with-sysroot=/usr/aarch64-linux-gnu
# Compile Libstdc++ by running
make -j$(nproc)
: ' 🚨 Unknown error when `make -j$(nproc)` 📅 2025-01-27 14:50:34
/home/pi19/gcc-14.2.0/build-libstdc++/include/limits:1989:1: error: invalid suffix "F32" on floating constant
 1989 | __glibcxx_float_n(32)
      | ^~~~~~~~~~~~~~~~~
/home/pi19/gcc-14.2.0/build-libstdc++/include/limits:1989:1: error: invalid suffix "F32" on floating constant
 1989 | __glibcxx_float_n(32)
'


# ../libstdc++-v3/configure \
#     --host=aarch64-linux-gnu \
#     --build=(../config.guess) \
#     --prefix=/usr/local/aarch64-linux-gnu \
#     --disable-multilib \
#     --disable-nls \
#     --disable-libstdcxx-pch \
#     --enable-threads=posix \
#     --with-gxx-include-dir=/usr/aarch64-linux-gnu/include/c++/14
#     # --with-sysroot=/usr/aarch64-linux-gnu
# # Compile Libstdc++ by running
# make -j$(nproc)

: ' 🚨 Unknown error when `make -j$(nproc)` 📅 2025-01-27 14:37:53
../../../libstdc++-v3/src/c++20/tzdb.cc:641:9: error: ‘mutex’ does not name a type; did you mean ‘minutes’?
  641 |         mutex infos_mutex;
      |         ^~~~~
      |         minutes
../../../libstdc++-v3/src/c++20/tzdb.cc: In member function ‘void std::chrono::time_zone::_Impl::RulesCounter<_Tp>::lock()’:
../../../libstdc++-v3/src/c++20/tzdb.cc:643:23: error: ‘infos_mutex’ was not declared in this scope
  643 |         void lock() { infos_mutex.lock(); }
      |                       ^~~~~~~~~~~
../../../libstdc++-v3/src/c++20/tzdb.cc: In member function ‘void std::chrono::time_zone::_Impl::RulesCounter<_Tp>::unlock()’:
../../../libstdc++-v3/src/c++20/tzdb.cc:644:25: error: ‘infos_mutex’ was not declared in this scope
  644 |         void unlock() { infos_mutex.unlock(); }
      |                         ^~~~~~~~~~~
make[3]: *** [Makefile:754: tzdb.lo] Error 1
make: *** [Makefile:502: all] Error 2
'
#
#  Now run the ./configure which must be checked/edited beforehand.
#  Uncomment the sections below depending on your platform.  You may build
#  on a Pi3 for a target Pi Zero by uncommenting the Pi Zero section.
#  To alter the target directory set --prefix=<dir>
#  For a very quick build try: --disable-bootstrap
#

# x86_64
# ../configure --disable-multilib --enable-languages=$LANG

# AArch64 Pi4 in 64-bit mode
../configure --enable-languages=$LANG --with-cpu=cortex-a72 --prefix=/usr/local --disable-multilib --disable-bootstrap


# Pi Zero and Pi1
#../configure --enable-languages=$LANG --with-cpu=arm1176jzf-s \
#  --with-fpu=vfp --with-float=hard --build=arm-linux-gnueabihf \
#  --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf

# Pi4 in 32-bit mode
#../configure --enable-languages=$LANG --with-cpu=cortex-a72 \
#  --with-fpu=neon-fp-armv8 --with-float=hard --build=arm-linux-gnueabihf \
#  --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf

# Pi3+, Pi3, new Pi2
#../configure --enable-languages=$LANG --with-cpu=cortex-a53 \
#  --with-fpu=neon-fp-armv8 --with-float=hard --build=arm-linux-gnueabihf \
#  --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf

# Old Pi2
#../configure --enable-languages=$LANG --with-cpu=cortex-a7 \
#  --with-fpu=neon-vfpv4 --with-float=hard --build=arm-linux-gnueabihf \
#  --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf

#
#  Now build GCC which will take a long time.  This could range from about
#  3 hours on an 8GB Pi4 up to over 100 hours on a 256MB Pi1.  It can be
#  left to complete overnight (or over the weekend for a Pi Zero :-)
#  The most likely causes of failure are lack of disk space, lack of
#  swap space or memory, or the wrong configure section uncommented.
#  The new compiler is placed in /usr/local/bin, the existing compiler remains
#  in /usr/bin and may be used by giving its version gcc-8 (say).
# https://www.linuxfromscratch.org/lfs/view/development/chapter05/gcc-libstdc++.html


if make -j$(nproc) libstdc++-v3
    echo ""
    echo -n "Do you wish to install the new GCC (y/n)? "
    read yn
    switch $yn
        case y Y
            sudo make install libstdc++-v3
        case '*'
            exit
    end
end


## https://developer.arm.com/Tools%20and%20Software/GNU%20Toolchain


## ❓ 이거 크로스컴파일할떄 이미 라이브러리 호스트에 있는데 이걸 복사하면 되는거 아닌가>?
