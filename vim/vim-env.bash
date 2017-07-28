#!/bin/bash
# File: vim-env.bash
# Author: lmcallme <l.m.zhongguo@gmial.com>
# Date: 28.07.2017
# Last Modified Date: 28.07.2017
# Last Modified By: lmcallme <l.m.zhongguo@gmial.com>

vim_env_p=$(pwd )

cd $(dirname "$0") || exit 1

export NAME=lmcallme

export EMAIL=l.m.zhongguo@gmial.com

# amix-vimrc's pathogen path
export PPATH=~/.vim_runtime/sources_non_forked

# amix-vimrc append vimrc_file
export MY_CONFIG=~/.vim_runtime/my_configs.vim

cd ${vim_env_p}
