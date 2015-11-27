#!/bin/bash

set -e

if [ ! "${TRAVIS}" == "true" ]
then
    echo "$0 can only be called inside a Travis-CI environment"
    exit 1
fi

case "${OS}" in
linux)
    CPACK_GENERATOR="TBZ2"
    ;;
osx)
    CPACK_GENERATOR="TBZ2"

    brew update
    brew outdated cmake || brew upgrade cmake
    brew outdated autoconf || brew upgrade autoconf
    brew outdated automake || brew upgrade automake
    brew outdated gmp || brew upgrade gmp
    brew outdated mpfr || brew upgrade mpfr
    brew outdated libmpc || brew upgrade libmpc
    brew outdated libtool || brew upgrade libtool
    brew outdated binutils || brew upgrade binutils
    brew outdated ninja || brew install ninja
    brew outdated libelf || brew install libelf
    brew outdated bison || brew install bison
    brew outdated flex || brew install flex
    brew outdated gawk || brew install gawk
    brew outdated texinfo || brew install texinfo
    ;;
mingw)
    if [ "${TRAVIS_OS_NAME}" == "osx" ]
    then
        echo "MinGW builds are not supported on OSX"
        exit 1
    fi

    CPACK_GENERATOR="ZIP"
    ;;
*)
    echo "Unrecognized OS: ${OS}"
    exit 1
    ;;
esac

mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

cmake \
  -DCMAKE_BUILD_TYPE="Release" \
  -DCPACK_GENERATOR=${CPACK_GENERATOR} \
  -DENABLE_DOC=OFF \
  -DENABLE_LIBCTRU=OFF \
  -DENABLE_LIBCTR=ON \
  -DENABLE_LLVM=OFF \
  -DENABLE_GCC=ON \
  ${SOURCE_DIR}

