#!/bin/bash
# File: create-swap-file.bash
# Author: lmcallme <l.m.zhongguo@gmial.com>
# Date: 24.07.2017
# Last Modified Date: 24.07.2017
# Last Modified By: lmcallme <l.m.zhongguo@gmial.com>

# https://docs.fedoraproject.org/en-US/Fedora/14/html/Storage_Administration_Guide/s2-swap-creating-file.html

SWAP_SIZE_MB=1024
SWAP_FILE=/swapfile

SWAP_SIZE=$(echo $(( ${SWAP_SIZE_MB} * 1024)) )

dd if=/dev/zero of=${SWAP_FILE} bs=1024 count=${SWAP_SIZE}
mkswap ${SWAP_FILE}
swapon ${SWAP_FILE}

#echo "${SWAP_FILE} swap    swap    defaults    0   0" >> /etc/fstab
