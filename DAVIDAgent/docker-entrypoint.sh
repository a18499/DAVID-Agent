#!/bin/bash
#set -e

# Set the SYSDIG_SKIP_LOAD variable to skip loading the sysdig kernel module

if [[ -z "${SYSDIG_SKIP_LOAD}" ]]; then
    echo "* Setting up /usr/src links from host"

    for i in $(ls $SYSDIG_HOST_ROOT/usr/src)
    do
        ln -s $SYSDIG_HOST_ROOT/usr/src/$i /usr/src/$i
    done

    /usr/bin/falco-probe-loader

fi

pwd

java -version

java -jar DockerLogger-1.0-SNAPSHOT.jar -Dlog4j.configurationFile=file:./Config/log4j-Logger.xml




