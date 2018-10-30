#!/bin/bash

source CONFIG

rm -rf *.deb
rm -rf build

mkdir build
cd build 

wget $URL
tar xvfz *.tar.gz

cd ..

fpm --deb-default systemd/${PROGRAM_NAME} \
  --deb-systemd systemd/${PROGRAM_NAME}.service \
  -s dir -t deb -n $PACKAGE_NAME \
  -v $VERSION-${DEB_VERSION} \
  build/${UPSTREAM_NAME}-${VERSION}.linux-amd64/${UPSTREAM_NAME}=usr/bin/${PROGRAM_NAME} ${EXTRA_INSTALL_DIRS}

deb-s3 upload --arch=${ARCH} \
  --bucket=${S3_BUCKET} \
  --codename=${CODENAME} \
  --s3-region=${S3_REGION} \
  --sign=${REPO_KEY_ID} ${PACKAGE_NAME}*.deb
