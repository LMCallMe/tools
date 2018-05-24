#!/bin/bash
# File              : tools/change-to-performance.sh
# Author            : lmcallme <l.m.zhongguo@gmial.com>
# Date              : 24.05.2018
# Last Modified Date: 24.05.2018
# Last Modified By  : lmcallme <l.m.zhongguo@gmial.com>

# https://www.gamingonlinux.com/articles/you-will-want-to-force-your-cpu-into-high-performance-mode-for-vulkan-games-on-linux.9369

# change ubuntu cpu mode to performance
echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
