#!/bin/bash
# File: install/install-add-apt-repository-on-ubuntu.bash
# Author: lmcallme <l.m.zhongguo@gmial.com>
# Date: 25.07.2017
# Last Modified Date: 25.07.2017
# Last Modified By: lmcallme <l.m.zhongguo@gmial.com>

# https://stackoverflow.com/questions/592620/check-if-a-program-exists-from-a-bash-script
# https://pricklytech.wordpress.com/2014/05/16/ubuntu-server-14-4-trusty-add-apt-repository-command-not-found/
hash add-apt-repository 2> /dev/null || sudo apt-get install software-properties-common
