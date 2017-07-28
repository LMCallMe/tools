#!/bin/bash
# File: vim/vim-win-gui-zh.bash
# Author: lmcallme <l.m.zhongguo@gmial.com>
# Date: 28.07.2017
# Last Modified Date: 28.07.2017
# Last Modified By: lmcallme <l.m.zhongguo@gmial.com>

source vim-env.bash

echo "set guifont=KaiTi:h10:cGB2312" >> ${MY_CONFIG}
echo "set encoding=GBK" >> ${MY_CONFIG}
echo "set ambiwidth=double" >> ${MY_CONFIG}
echo "set fileencoding=utf-8" >> ${MY_CONFIG}
echo "set fileencodings=utf-8,ucs-bom,cp936,gb18030,utf-16,big5,gbk,latin1" >> ${MY_CONFIG}
