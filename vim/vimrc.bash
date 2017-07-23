#!/bin/bash
# File: vimrc.bash
# Author: lmcallme <l.m.zhongguo@gmial.com>
# Date: 23.07.2017
# Last Modified Date: 23.07.2017
# Last Modified By: lmcallme <l.m.zhongguo@gmial.com>

cd $(dirname "$0") || exit 1

export NAME=lmcallme
export EMAIL=l.m.zhongguo@gmial.com

if [[ ! -d ~/.vim_runtime ]]; then
    
    # Install amix-vimrc

    git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
    sh ~/.vim_runtime/install_awesome_vimrc.sh
    #sh ~/vim_runtime/install_basic_vimrc.sh
fi

# amix-vim's pathogen path
export PPATH=~/.vim_runtime/sources_non_forked

# amix-vim's append vimrc_file
export MY_CONFIG=~/.vim_runtime/my_configs.vim

source vim-header.bash
source vim-mkdir.bash
