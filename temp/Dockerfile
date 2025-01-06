FROM debian:bookworm

# Fix symbolic link and prepare directories
RUN { \
    set -e && \
    echo "Fix symbolic link and create directories" && \
    wget https://raw.githubusercontent.com/riscv/riscv-poky/master/scripts/sysroot-relativelinks.py && \
    chmod +x sysroot-relativelinks.py && \
    python3 sysroot-relativelinks.py /build/sysroot && \
    mkdir -p qt6 qt6/host qt6/pi qt6/host-build qt6/pi-build qt6/src; \
    } 2>&1 | tee -a /build.log

### Download required submodules
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qtbase-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qtshadertools submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qtshadertools-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qtwebview submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qtwebview-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qtwebsockets submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qtwebsockets-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qtwebengine submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qtwebengine-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qtwebchannel submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qtwebchannel-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qtwayland submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qtwayland-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qtvirtualkeyboard submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qtvirtualkeyboard-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qttranslations submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qttranslations-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qttools submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qttools-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qtsvg submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qtsvg-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qtspeech submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qtspeech-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qtserialport submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qtserialport-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qtserialbus submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qtserialbus-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qtsensors submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qtsensors-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qtscxml submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qtscxml-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qtremoteobjects submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qtremoteobjects-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qtquicktimeline submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qtquicktimeline-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qtquickeffectmaker submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qtquickeffectmaker-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qtquick3dphysics submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qtquick3dphysics-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qtquick3d submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qtquick3d-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qtpositioning submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qtpositioning-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qtnetworkauth submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qtnetworkauth-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qtmultimedia submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qtmultimedia-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qtlottie submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qtlottie-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qtlocation submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qtlocation-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qtlanguageserver submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qtlanguageserver-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qtimageformats submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qtimageformats-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qthttpserver submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qthttpserver-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qtgrpc submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qtgrpc-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qtgraphs submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qtgraphs-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qtdoc submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qtdoc-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qtdatavis3d submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qtdatavis3d-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qtconnectivity submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qtconnectivity-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qtcharts submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qtcharts-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qtactiveqt submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qtactiveqt-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qt5compat submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qt5compat-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qt3d submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qt3d-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Download qtdeclarative submodule
RUN { set -e && cd qt6/src && \
    wget https://download.qt.io/official_releases/qt/6.8/6.8.0/submodules/qtdeclarative-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

### Extract and prepare host build
RUN { \
    set -e && \
    echo "Extract Qt modules for host build" && \
    cd qt6/host-build && \
    tar xf ../src/qtbase-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtshadertools-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtwebview-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtwebsockets-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtwebengine-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtwebchannel-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtwayland-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtvirtualkeyboard-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qttranslations-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qttools-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtsvg-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtspeech-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtserialport-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtserialbus-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtsensors-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtscxml-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtremoteobjects-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtquicktimeline-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtquickeffectmaker-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtquick3dphysics-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtquick3d-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtpositioning-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtnetworkauth-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtmultimedia-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtlottie-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtlocation-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtlanguageserver-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtimageformats-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qthttpserver-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtgrpc-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtgraphs-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtdoc-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtdatavis3d-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtconnectivity-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtcharts-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtactiveqt-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qt5compat-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qt3d-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtdeclarative-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Compile qtbase for host
RUN { \
    set -e && \
    echo "Compile qtbase for host" && \
    cd qt6/host-build/qtbase-everywhere-src-6.8.0 && \
    cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DQT_BUILD_EXAMPLES=OFF -DQT_BUILD_TESTS=OFF \
    -DCMAKE_INSTALL_PREFIX=/build/qt6/host && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtshadertools for host
RUN { \
    set -e && \
    echo "Compile qtshadertools for host" && \
    cd qt6/host-build/qtshadertools-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtwebview for host
RUN { \
    set -e && \
    echo "Compile qtwebview for host" && \
    cd qt6/host-build/qtwebview-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtwebsockets for host
RUN { \
    set -e && \
    echo "Compile qtwebsockets for host" && \
    cd qt6/host-build/qtwebsockets-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtwebengine for host
RUN { \
    set -e && \
    echo "Compile qtwebengine for host" && \
    cd qt6/host-build/qtwebengine-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtwebchannel for host
RUN { \
    set -e && \
    echo "Compile qtwebchannel for host" && \
    cd qt6/host-build/qtwebchannel-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtwayland for host
RUN { \
    set -e && \
    echo "Compile qtwayland for host" && \
    cd qt6/host-build/qtwayland-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtvirtualkeyboard for host
RUN { \
    set -e && \
    echo "Compile qtvirtualkeyboard for host" && \
    cd qt6/host-build/qtvirtualkeyboard-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qttranslations for host
RUN { \
    set -e && \
    echo "Compile qttranslations for host" && \
    cd qt6/host-build/qttranslations-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qttools for host
RUN { \
    set -e && \
    echo "Compile qttools for host" && \
    cd qt6/host-build/qttools-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtsvg for host
RUN { \
    set -e && \
    echo "Compile qtsvg for host" && \
    cd qt6/host-build/qtsvg-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtspeech for host
RUN { \
    set -e && \
    echo "Compile qtspeech for host" && \
    cd qt6/host-build/qtspeech-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtserialport for host
RUN { \
    set -e && \
    echo "Compile qtserialport for host" && \
    cd qt6/host-build/qtserialport-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtserialbus for host
RUN { \
    set -e && \
    echo "Compile qtserialbus for host" && \
    cd qt6/host-build/qtserialbus-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtsensors for host
RUN { \
    set -e && \
    echo "Compile qtsensors for host" && \
    cd qt6/host-build/qtsensors-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtscxml for host
RUN { \
    set -e && \
    echo "Compile qtscxml for host" && \
    cd qt6/host-build/qtscxml-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtremoteobjects for host
RUN { \
    set -e && \
    echo "Compile qtremoteobjects for host" && \
    cd qt6/host-build/qtremoteobjects-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtquicktimeline for host
RUN { \
    set -e && \
    echo "Compile qtquicktimeline for host" && \
    cd qt6/host-build/qtquicktimeline-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtquickeffectmaker for host
RUN { \
    set -e && \
    echo "Compile qtquickeffectmaker for host" && \
    cd qt6/host-build/qtquickeffectmaker-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtquickeffectmaker for host
RUN { \
    set -e && \
    echo "Compile qtquickeffectmaker for host" && \
    cd qt6/host-build/qtquickeffectmaker-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtquick3dphysics for host
RUN { \
    set -e && \
    echo "Compile qtquick3dphysics for host" && \
    cd qt6/host-build/qtquick3dphysics-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtquick3d for host
RUN { \
    set -e && \
    echo "Compile qtquick3d for host" && \
    cd qt6/host-build/qtquick3d-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtpositioning for host
RUN { \
    set -e && \
    echo "Compile qtpositioning for host" && \
    cd qt6/host-build/qtpositioning-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtnetworkauth for host
RUN { \
    set -e && \
    echo "Compile qtnetworkauth for host" && \
    cd qt6/host-build/qtnetworkauth-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtmultimedia for host
RUN { \
    set -e && \
    echo "Compile qtmultimedia for host" && \
    cd qt6/host-build/qtmultimedia-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtlottie for host
RUN { \
    set -e && \
    echo "Compile qtlottie for host" && \
    cd qt6/host-build/qtlottie-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtlocation for host
RUN { \
    set -e && \
    echo "Compile qtlocation for host" && \
    cd qt6/host-build/qtlocation-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtlanguageserver for host
RUN { \
    set -e && \
    echo "Compile qtlanguageserver for host" && \
    cd qt6/host-build/qtlanguageserver-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtimageformats for host
RUN { \
    set -e && \
    echo "Compile qtimageformats for host" && \
    cd qt6/host-build/qtimageformats-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qthttpserver for host
RUN { \
    set -e && \
    echo "Compile qthttpserver for host" && \
    cd qt6/host-build/qthttpserver-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtgrpc for host
RUN { \
    set -e && \
    echo "Compile qtgrpc for host" && \
    cd qt6/host-build/qtgrpc-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtgraphs for host
RUN { \
    set -e && \
    echo "Compile qtgraphs for host" && \
    cd qt6/host-build/qtgraphs-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtdoc for host
RUN { \
    set -e && \
    echo "Compile qtdoc for host" && \
    cd qt6/host-build/qtdoc-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtdatavis3d for host
RUN { \
    set -e && \
    echo "Compile qtdatavis3d for host" && \
    cd qt6/host-build/qtdatavis3d-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtconnectivity for host
RUN { \
    set -e && \
    echo "Compile qtconnectivity for host" && \
    cd qt6/host-build/qtconnectivity-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtcharts for host
RUN { \
    set -e && \
    echo "Compile qtcharts for host" && \
    cd qt6/host-build/qtcharts-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtactiveqt for host
RUN { \
    set -e && \
    echo "Compile qtactiveqt for host" && \
    cd qt6/host-build/qtactiveqt-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qt5compat for host
RUN { \
    set -e && \
    echo "Compile qt5compat for host" && \
    cd qt6/host-build/qt5compat-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qt3d for host
RUN { \
    set -e && \
    echo "Compile qt3d for host" && \
    cd qt6/host-build/qt3d-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtdeclarative for host
RUN { \
    set -e && \
    echo "Compile qtdeclarative for host" && \
    cd qt6/host-build/qtdeclarative-everywhere-src-6.8.0 && \
    /build/qt6/host/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Extract and prepare Raspberry Pi build
RUN { \
    set -e && \
    echo "Extract Qt modules for Raspberry Pi build" && \
    cd qt6/pi-build && \
    tar xf ../src/qtbase-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtshadertools-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtwebview-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtwebsockets-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtwebengine-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtwebchannel-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtwayland-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtvirtualkeyboard-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qttranslations-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qttools-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtsvg-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtspeech-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtserialport-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtserialbus-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtsensors-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtscxml-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtremoteobjects-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtquicktimeline-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtquickeffectmaker-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtquick3dphysics-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtquick3d-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtpositioning-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtnetworkauth-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtmultimedia-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtlottie-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtlocation-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtlanguageserver-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtimageformats-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qthttpserver-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtgrpc-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtgraphs-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtdoc-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtdatavis3d-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtconnectivity-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtcharts-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtactiveqt-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qt5compat-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qt3d-everywhere-src-6.8.0.tar.xz && \
    tar xf ../src/qtdeclarative-everywhere-src-6.8.0.tar.xz; \
    } 2>&1 | tee -a /build.log

# Compile qtbase for Raspberry Pi
RUN { \
    set -e && \
    echo "Compile qtbase for Raspberry Pi" && \
    cd qt6/pi-build/qtbase-everywhere-src-6.8.0 && \
    cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DINPUT_opengl=es2 -DQT_BUILD_EXAMPLES=OFF -DQT_BUILD_TESTS=OFF \
    -DQT_HOST_PATH=/build/qt6/host -DCMAKE_STAGING_PREFIX=/build/qt6/pi \
    -DCMAKE_INSTALL_PREFIX=/usr/local/qt6 -DCMAKE_TOOLCHAIN_FILE=/build/toolchain.cmake \
    -DQT_FEATURE_xcb=ON -DFEATURE_xcb_xlib=ON -DQT_FEATURE_xlib=ON && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtshadertools, qtwebview, qtwebsockets for Raspberry Pi
RUN { \
    set -e && \
    echo "Compile qtshadertools for Raspberry Pi" && \
    cd qt6/pi-build/qtshadertools-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    echo "Compile qtwebview for Raspberry Pi" && \
    cd ../qtwebview-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    echo "Compile qtwebsockets for Raspberry Pi" && \
    cd ../qtwebsockets-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtwebengine, qtwebchannel, qtwayland for Raspberry Pi
RUN { \
    set -e && \
    echo "Compile qtwebengine for Raspberry Pi" && \
    cd qt6/pi-build/qtwebengine-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    echo "Compile qtwebchannel for Raspberry Pi" && \
    cd ../qtwebchannel-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    echo "Compile qtwayland for Raspberry Pi" && \
    cd ../qtwayland-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtvirtualkeyboard, qttranslations, qttools for Raspberry Pi
RUN { \
    set -e && \
    echo "Compile qtvirtualkeyboard for Raspberry Pi" && \
    cd qt6/pi-build/qtvirtualkeyboard-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    echo "Compile qttranslations for Raspberry Pi" && \
    cd ../qttranslations-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    echo "Compile qttools for Raspberry Pi" && \
    cd ../qttools-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtsvg, qtspeech, qtserialport for Raspberry Pi
RUN { \
    set -e && \
    echo "Compile qtsvg for Raspberry Pi" && \
    cd qt6/pi-build/qtsvg-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    echo "Compile qtspeech for Raspberry Pi" && \
    cd ../qtspeech-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    echo "Compile qtserialport for Raspberry Pi" && \
    cd ../qtserialport-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtserialbus, qtsensors, qtscxml for Raspberry Pi
RUN { \
    set -e && \
    echo "Compile qtserialbus for Raspberry Pi" && \
    cd qt6/pi-build/qtserialbus-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    echo "Compile qtsensors for Raspberry Pi" && \
    cd ../qtsensors-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    echo "Compile qtscxml for Raspberry Pi" && \
    cd ../qtscxml-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtremoteobjects, qtquicktimeline, qtquickeffectmaker for Raspberry Pi
RUN { \
    set -e && \
    echo "Compile qtremoteobjects for Raspberry Pi" && \
    cd qt6/pi-build/qtremoteobjects-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    echo "Compile qtquicktimeline for Raspberry Pi" && \
    cd ../qtquicktimeline-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    echo "Compile qtquickeffectmaker for Raspberry Pi" && \
    cd ../qtquickeffectmaker-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtquick3dphysics, qtquick3d, qtpositioning for Raspberry Pi
RUN { \
    set -e && \
    echo "Compile qtquick3dphysics for Raspberry Pi" && \
    cd qt6/pi-build/qtquick3dphysics-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    echo "Compile qtquick3d for Raspberry Pi" && \
    cd ../qtquick3d-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    echo "Compile qtpositioning for Raspberry Pi" && \
    cd ../qtpositioning-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtnetworkauth, qtmultimedia, qtlottie for Raspberry Pi
RUN { \
    set -e && \
    echo "Compile qtnetworkauth for Raspberry Pi" && \
    cd qt6/pi-build/qtnetworkauth-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    echo "Compile qtmultimedia for Raspberry Pi" && \
    cd ../qtmultimedia-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    echo "Compile qtlottie for Raspberry Pi" && \
    cd ../qtlottie-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtlocation, qtlanguageserver, qtimageformats for Raspberry Pi
RUN { \
    set -e && \
    echo "Compile qtlocation for Raspberry Pi" && \
    cd qt6/pi-build/qtlocation-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    echo "Compile qtlanguageserver for Raspberry Pi" && \
    cd ../qtlanguageserver-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    echo "Compile qtimageformats for Raspberry Pi" && \
    cd ../qtimageformats-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qthttpserver, qtgrpc, qtgraphs for Raspberry Pi
RUN { \
    set -e && \
    echo "Compile qthttpserver for Raspberry Pi" && \
    cd qt6/pi-build/qthttpserver-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    echo "Compile qtgrpc for Raspberry Pi" && \
    cd ../qtgrpc-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    echo "Compile qtgraphs for Raspberry Pi" && \
    cd ../qtgraphs-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtdoc, qtdatavis3d, qtconnectivity for Raspberry Pi
RUN { \
    set -e && \
    echo "Compile qtdoc for Raspberry Pi" && \
    cd qt6/pi-build/qtdoc-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    echo "Compile qtdatavis3d for Raspberry Pi" && \
    cd ../qtdatavis3d-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    echo "Compile qtconnectivity for Raspberry Pi" && \
    cd ../qtconnectivity-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qtcharts, qtactiveqt, qt5compat for Raspberry Pi
RUN { \
    set -e && \
    echo "Compile qtcharts for Raspberry Pi" && \
    cd qt6/pi-build/qtcharts-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    echo "Compile qtactiveqt for Raspberry Pi" && \
    cd ../qtactiveqt-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    echo "Compile qt5compat for Raspberry Pi" && \
    cd ../qt5compat-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Compile qt3d, qtdeclarative for Raspberry Pi
RUN { \
    set -e && \
    echo "Compile qt3d for Raspberry Pi" && \
    cd qt6/pi-build/qt3d-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    echo "Compile qtdeclarative for Raspberry Pi" && \
    cd ../qtdeclarative-everywhere-src-6.8.0 && \
    /build/qt6/pi/bin/qt-configure-module . && \
    cmake --build . --parallel 4 && \
    cmake --install .; \
    } 2>&1 | tee -a /build.log

# Final step: Compilation finished
RUN { \
    set -e && \
    echo "Compilation is finished"; \
    } 2>&1 | tee -a /build.log
