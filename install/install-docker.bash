#!/bin/bash
# File: install-docker.bash
# Author: lmcallme <l.m.zhongguo@gmial.com>
# Date: 23.07.2017
# Last Modified Date: 23.07.2017
# Last Modified By: lmcallme <l.m.zhongguo@gmial.com>

# https://developer.fedoraproject.org/tools/docker/docker-installation.html
if [[ -f /etc/redhat-release ]]; then
    sudo dnf install docker
    sudo systemctl start docker
    sudo systemctl enable docker
fi

#https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-using-the-repository
if [[ -f /etc/debian_version ]]; then
    sudo apt-get install \
        linux-image-extra-$(uname -r) \
        linux-image-extra-virtual
    sudo apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo apt-key fingerprint 0EBFCD88
    sudo add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable"
    sudo apt-get install docker-ce
fi

source install-docker-no-sudo-run.bash
