#!/bin/bash
# File: install/install-python-virtualenv.bash
# Author: lmcallme <l.m.zhongguo@gmial.com>
# Date: 23.07.2017
# Last Modified Date: 23.07.2017
# Last Modified By: lmcallme <l.m.zhongguo@gmial.com>

#http://pythonguidecn.readthedocs.io/zh/latest/dev/virtualenvs.html

case "$(uname -s)" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGW;;
    *)          machine="UNKNOWN_ENV"
esac

echo "machine is ${machine}"

if [[ ${machine} == Linux ]]; then
    pip install --user virtualenv
    pip install --user virtualenvwrapper
    echo "export WORKON_HOME=~/Envs" >> ~/.bashrc
    echo "source ~/.local/bin/virtualenvwrapper.sh" >> ~/.bashrc
    source ~/.bashrc
fi

if [[ ${machine} == Cygwin || ${machine} == MinGW ]]; then
    pip install virtualenv
    pip install virtualenvwrapper-win
fi

