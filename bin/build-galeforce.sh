#! /bin/bash

pushd $(dirname "$0")
source ./common.sh

BUSYBOX_URL="https://busybox.net/downloads/binaries/1.31.0-defconfig-multiarch-musl/busybox-armv5l"
DROPBEAR_URL="http://archive.raspbian.org/raspbian/pool/main/d/dropbear/dropbear-bin_2024.85-1_armhf.deb"

function downloadBusybox() {
  if [ ! -f "$DOWNLOADS_DIR/busybox" ]
  then
    echo "Downloading busybox"
    curl -s $BUSYBOX_URL -o $DOWNLOADS_DIR/busybox
    chmod +x $DOWNLOADS_DIR/busybox
  fi
}

function downloadDropbear() {
  if [ ! -f "$DOWNLOADS_DIR/dropbear" ]
  then
    echo "Downloading dropbear"
    mkdir -p $DOWNLOADS_DIR/extract
    pushd $DOWNLOADS_DIR/extract
    curl -s $DROPBEAR_URL -o dropbear.deb
    ar -x dropbear.deb
    tar -xf data.tar.xz
    cp usr/sbin/dropbear ../
    popd
    rm -rf $DOWNLOADS_DIR/extract
  fi
}

echo "Building GaleForce."

rm -rf $BUILD_DIR/galeforce
downloadDropbear
downloadBusybox
cp -R "../galeforce" $BUILD_DIR/galeforce
cp $DOWNLOADS_DIR/dropbear $BUILD_DIR/galeforce/bin
chmod 700 $BUILD_DIR/galeforce/bin/dropbear

cp $DOWNLOADS_DIR/busybox $BUILD_DIR/galeforce/bin
chmod u+x $BUILD_DIR/galeforce/bin/busybox

pushd $BUILD_DIR
tar -czf galeforce.tar.gz galeforce
popd

cp $BUILD_DIR/galeforce.tar.gz $OUTPUT_DIR

popd