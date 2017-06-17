FROM fishead/node-opencv
LABEL dlib Yin jiao<yinjiao@jcble.com>

WORKDIR /usr/local/src


#install dlib
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
