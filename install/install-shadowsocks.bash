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

_CONFIG_=/etc/shadowshock.json
if [ ! -e $_CONFIG_ ]; then
    sudo cp $DIR/etc/shadowsocks.json $_CONFIG_
fi

_SSSERVER_=$DIR/service/ssserver.service

echo "[Unit]" > $_SSSERVER_
echo "Description=Shadowsocka Server" >> $_SSSERVER_
echo "After=network.target" >> $_SSSERVER_

echo "[Service]" >> $_SSSERVER_
echo "Type=forking" >> $_SSSERVER_
BIN_SSSERVER=${HOME}/.local/bin/ssserver
echo "ExecStart=${BIN_SSSERVER} -c ${_CONFIG_} -d start" >> $_SSSERVER_
echo "ExecStop=${BIN_SSSERVER} -c ${_CONFIG_} -d stop" >> $_SSSERVER_
echo "ExecReload=${BIN_SSSERVER} -c ${_CONFIG_} -d restart" >> $_SSSERVER_
echo "Restart=on-abort" >> $_SSSERVER_

echo "[Install]" >> $_SSSERVER_
echo "WantedBy=multi-user.target" >> $_SSSERVER_

sudo cp $_SSSERVER_ /lib/systemd/system/ssserver.service

sudo systemctl enable ssserver
sudo systemctl start ssserver
