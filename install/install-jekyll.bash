#!/bin/bash
# File: install-jekyll.bash
# Author: lmcallme <l.m.zhongguo@gmial.com>
# Date: 23.07.2017
# Last Modified Date: 23.07.2017
# Last Modified By: lmcallme <l.m.zhongguo@gmial.com>

if [[ -e /etc/redhat-release ]]; then
    sudo dnf install gem
    sudo dnf install redhat-rpm-config
    gem install json_pure
fi

if [[ -e /etc/debian_version ]]; then
    apt-get install gem
fi

gem install jekyll bundler
gem update

