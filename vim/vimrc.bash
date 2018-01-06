#!/bin/bash
# File: vimrc.bash
# Author: lmcallme <l.m.zhongguo@gmial.com>
# Date: 23.07.2017
# Last Modified Date: 23.07.2017
# Last Modified By: lmcallme <l.m.zhongguo@gmial.com>

source vim-env.bash

if [[ ! -d ~/.vim_runtime ]]; then
    
    # Install amix-vimrc
    sudo apt-get install ack-grep # install ack command for ack.vim
    git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
    sh ~/.vim_runtime/install_awesome_vimrc.sh
    #sh ~/vim_runtime/install_basic_vimrc.sh
fi

vimrc_p=$(pwd )

cd $(dirname "$0") || exit 1

source vim-header.bash
source vim-mkdir.bash

cd ${vimrc_p}
