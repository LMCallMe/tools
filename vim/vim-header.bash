#!/bin/bash
# File: vim-header.bash
# Author: lmcallme <l.m.zhongguo@gmial.com>
# Date: 23.07.2017
# Last Modified Date: 23.07.2017
# Last Modified By: lmcallme <l.m.zhongguo@gmial.com>

INSTALL_PATH=${PPATH}/vim-header
GIT_URL=https://github.com/alpertuna/vim-header

if [ ! -d INSTALL_PATH ]; then
    # Install vim-header
    git clone --depth=1 ${GIT_URL} ${INSTALL_PATH}
    
    # Config vim-header
    echo "let g:header_field_author = '${NAME}'" >> ${MY_CONFIG}
    echo "let g:header_field_author_email = '${EMAIL}'" >> ${MY_CONFIG}
    # disable auto add header
    ehco "let g:header_auto_add_header = 0" >> ${MY_CONFIG}
    # echo "map <F4> :AddHeader" >> ${MY_CONFIG}

    echo "installed vim-header"
fi
