#!/bin/bash
mkdir ~/DockerLog/
sudo docker run -i -t --name falco --privileged -v /var/run/docker.sock:/var/run/docker.sock -v /dev:/host/dev -v /proc:/host/proc:ro -v /boot:/host/boot:ro -v /lib/modules:/host/lib/modules:ro -v /usr:/host/usr:ro -v ~/DockerLog:/home/DataLog/:rw davidagent:v1.7
