FROM debian:jessie
LABEL dlib Yin jiao<yinjiao@jcble.com>

WORKDIR /usr/local/src

#install opencv3
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential cmake git libgtk2.0-dev pkg-config \
    libavcodec-dev libavformat-dev libswscale-dev \
    ca-certificates libhdf5-dev


RUN git clone -b 3.2.0 --depth 1 https://github.com/opencv/opencv.git /usr/local/src/opencv
RUN git clone -b 3.2.0 --depth 1 https://github.com/opencv/opencv_contrib.git /usr/local/src/opencv_contrib


RUN cd /usr/local/src/opencv && \
    mkdir build && \
    cd build && \
    cmake -D CMAKE_INSTALL_PREFIX=/usr/local \
          -D BUILD_TESTS=OFF \
          -D BUILD_PERF_TESTS=OFF \
          -D PYTHON_DEFAULT_EXECUTABLE=$(which python3) \
          -D OPENCV_EXTRA_MODULES_PATH=/usr/local/src/opencv_contrib/modules \
          .. && \
    make -j"$(nproc)" && \
    make install && \
    ldconfig

#install dlib_change_save_size_to_256
RUN apt-get update &&\
    apt-get install -y --no-install-recommends python libboost-dev cmake
RUN cd /usr/local/src  &&\
    git clone  --depth 1 https://github.com/davisking/dlib.git  && \
    cd dlib/examples && \
    mkdir build && \
    cd build && \
    cmake .. && \
    cmake --build . --config Release && \
    cd ../ && \
    wget http://dlib.net/files/shape_predictor_68_face_landmarks.dat.bz2 && \
    bunzip2 shape_predictor_68_face_landmarks.dat.bz2

RUN apt-get update && apt-get install -y \
  build-essential autoconf libtool \
  git \
  pkg-config \
  && apt-get clean

ENV GRPC_RELEASE_TAG v1.0.0

RUN git clone -b ${GRPC_RELEASE_TAG} https://github.com/grpc/grpc /var/local/git/grpc

# install grpc
RUN cd /var/local/git/grpc && \
    git submodule update --init && \
    make && \
    make install && make clean

#install protoc
RUN cd /var/local/git/grpc/third_party/protobuf && \
    make && make install && make clean
