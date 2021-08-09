FROM ubuntu:focal
SHELL ["/bin/bash", "-c"]

# Environmental variables.
ENV DEBIAN_FRONTEND noninteractive
ENV SWIFT_PRODUCT_NAME godot-project
ENV SWIFT_BUILD_TYPE debug
ENV GODOT_PROJECT_LIBRARIES_DIRECTORY game/libraries
ENV GODOT_BUILD_TYPE debug

# Update and install dependencies from apt.
RUN apt-get update &&\
    apt-get install -y \
    git \
    curl \
    build-essential \
    libstdc++6 \
    lsb-release \
    libatomic1 \
    libcurl4 \
    libxml2 \
    libedit2 \
    libsqlite3-dev \
    libc6-dev \
    binutils \
    zlib1g-dev \
    libpython3.6 \
    libncurses5-dev \
    pkg-config

# Clone the swiftenv project, update environment and reload the shell.
RUN git clone https://github.com/kylef/swiftenv.git ~/.swiftenv &&\
    echo 'export SWIFTENV_ROOT="$HOME/.swiftenv"' >> ~/.bash_profile &&\
    echo 'export PATH="$SWIFTENV_ROOT/bin:$PATH"' >> ~/.bash_profile &&\
    echo 'eval "$(swiftenv init -)"' >> ~/.bash_profile &&\
    source ~/.bash_profile

# Install and activate the development snapshot of Swift.
RUN source ~/.bash_profile &&\
    swiftenv install https://swift.org/builds/development/ubuntu2004/swift-DEVELOPMENT-SNAPSHOT-2021-06-01-a/swift-DEVELOPMENT-SNAPSHOT-2021-06-01-a-ubuntu20.04.tar.gz &&\ 
    swiftenv global DEVELOPMENT-SNAPSHOT-2021-06-01-a &&\
    swiftenv version

# Create tools directory, add build install tool, finally create build directory.
WORKDIR /tools
ADD build .
WORKDIR /build

# Reload bash profile, build Swift project, and generate Godot libraries.
CMD source ~/.bash_profile &&\
    SWIFTPM_ENABLE_PLUGINS=1 swift build --product ${SWIFT_PRODUCT_NAME} -c ${SWIFT_BUILD_TYPE} &&\
    /tools/build --configuration ${GODOT_BUILD_TYPE} --install ${GODOT_PROJECT_LIBRARIES_DIRECTORY} --working-directory "/build"
