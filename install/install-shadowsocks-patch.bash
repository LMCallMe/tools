#!/bin/bash
# File              : install-shadowsocks-patch.bash
# Author            : lmcallme <l.m.zhongguo@gmial.com>
# Date              : 21.05.2018
# Last Modified Date: 21.05.2018
# Last Modified By  : lmcallme <l.m.zhongguo@gmial.com>
# https://blog.csdn.net/blackfrog_unique/article/details/60320737
# openssl1.1.0 : EVP_CIPHER_CTX_cleanup -> EVP_CIPHER_CTX_reset
# change file shadowsocks/crypto/openssl.py

CHANGED_FILE=${HOME}/.local/lib/python2.7/site-packages/shadowsocks/crypto/openssl.py

sed -i sed -i "s/EVP_CIPHER_CTX_cleanup/EVP_CIPHER_CTX_reset/g" ${CHANGED_FILE}
