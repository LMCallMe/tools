#!/bin/bash
# File: change-docker-zh.bash
# Author: lmcallme <l.m.zhongguo@gmial.com>
# Date: 23.07.2017
# Last Modified Date: 23.07.2017
# Last Modified By: lmcallme <l.m.zhongguo@gmial.com>

# 国内镜像源各种不稳定，或者注册复杂建议直接 proxychain4 docker run/pull
if [[ -f /etc/containers/registries.conf ]]; then
    echo "find registries.conf"
    sudo sed -i -e 's/^registries:$/registries:\n  - docker.mirrors.ustc.edu.cn/g' /etc/containers/registries.conf
fi
