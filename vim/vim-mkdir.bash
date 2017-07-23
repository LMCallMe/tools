#!/bin/bash
# File: vim-mkdir.bash
# Author: lmcallme <l.m.zhongguo@gmial.com>
# Date: 23.07.2017
# Last Modified Date: 23.07.2017
# Last Modified By: lmcallme <l.m.zhongguo@gmial.com>

INSTALL_PATH=${PPATH}/vim-mkdir
GIT_URL=https://github.com/pbrisbin/vim-mkdir.git

if [ ! -d INSTALL_PATH ]; then
    # Install vim-mkdir
    git clone --depth=1 ${GIT_URL} ${INSTALL_PATH}
    
    echo "installed vim-mkdir"
fi
