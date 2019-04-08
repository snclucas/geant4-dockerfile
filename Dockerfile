FROM ubuntu

MAINTAINER Simon Clucas <simon@blueapoge.com>

# Prepare system
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install cmake build-essential qt4-dev-tools libexpat1-dev libboost-all-dev -y

RUN apt-get install xfonts-75dpi xfonts-100dpi imagemagick wget -y

# module load cmake/3.4.3

ENV SW_NAME=geant4
ENV PACKAGE_VERSION=10.05
ENV PACKAGE_NAME=$SW_NAME.$PACKAGE_VERSION
ENV PACKAGE_DIR=/g4_install/packages
ENV PACKAGE_FILE=$PACKAGE_DIR/$PACKAGE_NAME.tar.gz
ENV URL=http://geant4.cern.ch/support/source/$PACKAGE_NAME.tar.gz
ENV INSTALL_DIR=/opt/$PACKAGE_NAME

ENV MAKE_PROCESSES=4

RUN mkdir -p $PACKAGE_DIR

RUN cd $PACKAGE_DIR
WORKDIR $PACKAGE_DIR
RUN wget $URL -P $PACKAGE_DIR

ENV  BUILD_DIR=.
RUN cd $BUILD_DIR
WORKDIR $BUILD_DIR
RUN tar xzf $PACKAGE_FILE

RUN mkdir build
RUN cd build
WORKDIR ./build

RUN cmake -DGEANT4_FORCE_QT4=ON -DGEANT4_USE_QT=ON -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR -DGEANT4_BUILD_MULTITHREADED=ON -DGEANT4_INSTALL_DATA=ON  ../$PACKAGE_NAME

run make -j$MAKE_PROCESSES install

# Reduce image size
RUN apt-get autoremove; apt-get clean
