#!/bin/bash
# File              : tools/killgrep.sh
# Author            : lmcallme <l.m.zhongguo@gmial.com>
# Date              : 14.06.2018
# Last Modified Date: 14.06.2018
# Last Modified By  : lmcallme <l.m.zhongguo@gmial.com>

ps aux | grep $1 | awk '{print $2}' | xargs kill -9
