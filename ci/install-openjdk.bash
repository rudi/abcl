#!/usr/bin/env bash
DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. ${DIR}/install-jenv.bash

jdk=$1
if [[ -z $jdk ]]; then
    jdk=openjdk8
fi

# empty variables are not necessary, but a hint that these are not
# lexically scoped in their modification.
topdir=
dist=
function determine_openjdk() {
    case $(uname) in
        Darwin)
            case $jdk in
                openjdk8)
                    topdir=jdk8u302-b08
                    dist="https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u302-b08/OpenJDK8U-jdk_x64_mac_hotspot_8u302b08.tar.gz"
                    ;;
                openjdk11)
                    topdir=jdk-11.0.12+7
                    dist="https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.12%2B7/OpenJDK11U-jdk_x64_mac_hotspot_11.0.12_7.tar.gz"
                    ;;
                openjdk14)  # Need version from adoptium
                    topdir=jdk-14.0.2+12
                    dist="https://github.com/AdoptOpenJDK/openjdk14-binaries/releases/download/jdk-14.0.2%2B12/OpenJDK14U-jdk_x64_mac_hotspot_14.0.2_12.tar.gz"
                    ;;
                openjdk15) # Need version from adoptium
                    topdir=jdk-15+36
                    dist="https://github.com/AdoptOpenJDK/openjdk15-binaries/releases/download/jdk-15%2B36/OpenJDK15U-jdk_x64_mac_hotspot_15_36.tar.gz"
                    ;;
                openjdk16)
                    topdir=jdk-16.0.2+7
                    dist="https://github.com/adoptium/temurin16-binaries/releases/download/jdk-16.0.2%2B7/OpenJDK16U-jdk_x64_mac_hotspot_16.0.2_7.tar.gz"
                    ;;
                openjdk17)
                    topdir="jdk-17+35"
                    dist="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17%2B35/OpenJDK17-jdk_x64_mac_hotspot_17_35.tar.gz"
                    ;;
            esac
            ;;
        Linux)
            case $jdk in
                openjdk8)
                    topdir=jdk8u302-b08
                    dist="https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u302-b08/OpenJDK8U-jdk_x64_linux_hotspot_8u302b08.tar.gz"
                    ;;
                openjdk11)
                    topdir=jdk-11.0.8+10
                    dist="https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.8%2B10/OpenJDK11U-jdk_x64_linux_hotspot_11.0.8_10.tar.gz"
                    ;;
                openjdk14) # Need version from adoptium
                    topdir=jdk-14.0.2+12
                    dist="https://github.com/AdoptOpenJDK/openjdk14-binaries/releases/download/jdk-14.0.2%2B12/OpenJDK14U-jdk_x64_linux_hotspot_14.0.2_12.tar.gz"
                    ;;
                openjdk15) # Need version from adoptium
                    topdir=jdk-15+36
                    dist="https://github.com/AdoptOpenJDK/openjdk15-binaries/releases/download/jdk-15%2B36/OpenJDK15U-jdk_x64_linux_hotspot_15_36.tar.gz"
                    ;;
                openjdk16)
                    topdir=jdk-16.0.2+7
                    dist="https://github.com/adoptium/temurin16-binaries/releases/download/jdk-16.0.2%2B7/OpenJDK16U-jdk_x64_linux_hotspot_16.0.2_7.tar.gz"
                    ;;
                openjdk17)
                    topdir="jdk-17+35"
                    dist="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17%2B35/OpenJDK17-jdk_x64_linux_hotspot_17_35.tar.gz"
                    ;;
esac
            ;;
        *)
            echo No known dist for $(uname)
    esac
}

tmpdir=/var/tmp

function download_and_extract() {
    pushd ${tmpdir} && wget --continue ${dist}
    
    tar xvz -f $(basename ${dist})

    popd
}

function add_jdk() {
    echo $dist
    echo $tmpdir
    case $(uname) in
        Darwin)
            jenv add ${tmpdir}/${topdir}/Contents/Home
            ;;
        Linux)
            jenv add ${tmpdir}/${topdir}
            ;;
    esac
}

determine_openjdk
download_and_extract
add_jdk

. ${DIR}/set-jdk.bash

jenv doctor
