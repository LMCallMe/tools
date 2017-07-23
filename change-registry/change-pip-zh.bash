#!/bin/bash
# File: change-pip-zh.bash
# Author: lmcallme <l.m.zhongguo@gmial.com>
# Date: 23.07.2017
# Last Modified Date: 23.07.2017
# Last Modified By: lmcallme <l.m.zhongguo@gmial.com>

PWD_PATH=$(pwd )
cd $(dirname "$0") || exit 1

CONFIG_DIR=~/.pip
CONFIG_FILE=${CONFIG_DIR}/pip.conf
MIRROR_HOST=mirrors.aliyun.com
INDEX_URL=http://${MIRROR_HOST}/pypi/simple

if [[ ! -d ${CONFIG_DIR} ]]; then
    mkdir -p ${CONFIG_DIR}
fi

if [[ ! -e ${CONFIG_FILE} ]]; then
    echo "[global]" >> ${CONFIG_FILE}
    echo "trushed-host = ${MIRROR_HOST}" >> ${CONFIG_FILE}
    echo "index-url = ${INDEX_URL}" >> ${CONFIG_FILE}
else
    sed -i -e "s/trusted-host.*$/trushed-host = ${MIRROR_HOST}/g" ${CONFIG_FILE} 
    sed -i -e "s/index-url.*$/index-url = ${MIRROR_HOST}/g" ${CONFIG_FILE} 
fi

cd ${PWD_PATH}

