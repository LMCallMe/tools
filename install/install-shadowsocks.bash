#!/bin/bash
# File              : install-shadowsocks.bash
# Author            : lmcallme <l.m.zhongguo@gmial.com>
# Date              : 21.05.2018
# Last Modified Date: 21.05.2018
# Last Modified By  : lmcallme <l.m.zhongguo@gmial.com>

sudo apt install python-pip
pip install shadowsocks

#保存PWD
_SAVED_PWD=$PWD
#获得该文件的位置
echo "$0" | grep -q "$0"
if [ $? -eq 0 ]; then
     cd "$(dirname "$BASH_SOURCE")"
     CUR_FILE=$(pwd)/$(basename "$BASH_SOURCE")
     CUR_DIR=$(dirname "$CUR_FILE")
     cd - > /dev/null
else
     if [ ${0:0:1} = "/" ]; then
             CUR_FILE=$0
     else
             CUR_FILE=$(pwd)/$0
     fi
     CUR_DIR=$(dirname "$CUR_FILE")
fi
#去掉路径中的相对路径，如a/..b/c
cd "$CUR_DIR"
DIR=$PWD
cd - > /dev/null
#恢复 PWD
cd "$_SAVED_PWD"

sudo cp $DIR/etc/shadowsocks.json /etc/shadowsocks.json
sudo cp $DIR/service/ssserver.service /lib/systemd/system/ssserver.service
sudo systemctl enable ssserver
sudo systemctl start ssserver
